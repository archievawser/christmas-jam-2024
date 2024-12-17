extends RigidBody2D


@export var moveSpeed: float;
@export var jumpForce: float;
@export var camera: Camera2D;
@export var cameraSpeed: float;
@export var torso: Sprite2D;
@export var root: Node2D;

# movement
var gravity: float = 2500;
var facingRight: bool = false;
var headFacingRight: bool = false;
var velocity: Vector2;

# procedural animation
var limbNames: Array = ["head", "arm-left", "arm-right", "leg-left", "leg-right"];
var armNames: Array = ["arm-left", "arm-right"];
var legNames: Array = ["leg-left", "leg-right"];
var limbSockets: Dictionary;
var limbs: Dictionary;
var headFlipOffset: float;

# to make code less ugly
var frameDelta: float;


func _ready() -> void:
	_setup_limb_lookup();
	_update_limb_positions();

	headFlipOffset = limbs["head"].offset.x;


func _process(delta: float) -> void:
	frameDelta = delta;

	_apply_gravity();
	_apply_character_movement();
	_update_camera_position();
	_update_limb_positions();
	_update_head_rotation();

	if Input.is_action_just_pressed("jump"):
		velocity += Vector2.UP * jumpForce;

	
func _setup_limb_lookup() -> void:
	for limbName in limbNames:
		limbs[limbName] = root.find_child(limbName);
		limbSockets[limbName] = torso.find_child(limbName + "-socket");


func _lerp_limb_to_socket(limbName, speed) -> void:
	limbs[limbName].position = lerp(limbs[limbName].position, limbSockets[limbName].global_position, speed * frameDelta);


func _move_limb_to_socket(limbName) -> void:
	limbs[limbName].position = limbSockets[limbName].global_position;


func _update_limb_positions() -> void:
	for armName in armNames:
		_lerp_limb_to_socket(armName, 30);

	for legName in legNames:
		_move_limb_to_socket(legName);
	
	_move_limb_to_socket("head");


func _get_movement_vector() -> Vector2:
	var movementX = (1 if Input.is_action_pressed("move_right") else 0) - (1 if Input.is_action_pressed("move_left") else 0);

	return moveSpeed * frameDelta * Vector2(movementX, 0);


func _apply_character_movement() -> void:
	var move = _get_movement_vector();
	
	self.move_and_collide(move);


func _face_character_right() -> void:
	facingRight = true;
	torso.flip_h = true;

	limbs["arm-right"].z_index = -1;
	limbs["arm-left"].z_index = 1;


func _face_head_right() -> void:
	var head: Sprite2D = limbs["head"];
	head.offset.x = headFlipOffset * 2;
	head.flip_h = true;
	headFacingRight = true;


func _face_character_left() -> void:
	facingRight = false;
	torso.flip_h = false;

	limbs["arm-right"].z_index = 1;
	limbs["arm-left"].z_index = -1;


func _face_head_left() -> void:
	var head: Sprite2D = limbs["head"];
	head.offset.x = headFlipOffset;
	head.flip_h = false;
	headFacingRight = false;


var lastHeadDirection: Vector2;
func _update_head_rotation() -> void:
	var head = limbs["head"];
	var mousePos = camera.get_global_mouse_position();
	var direction = mousePos - head.position;
	var angle = atan2(direction.y, direction.x);
	var headShouldFlip = sign(direction.x) != sign(lastHeadDirection.x);

	if headShouldFlip:
		if direction.x > 0:
			_face_character_right();
			_face_head_right();
		else:
			_face_character_left();
			_face_head_left();

	_set_head_rotation(angle);

	lastHeadDirection = direction;


func _set_head_rotation(radians: float) -> void:
	limbs["head"].rotation = radians if headFacingRight else radians - PI;


func _update_camera_position() -> void:
	camera.position = lerp(camera.position, self.position, cameraSpeed * frameDelta);


func _apply_gravity() -> void:
	velocity += Vector2.DOWN * gravity * frameDelta;

	var collision = self.move_and_collide(velocity * frameDelta);
	self.move_and_collide(_get_movement_vector());

	if collision:
		velocity = Vector2.DOWN * 2;