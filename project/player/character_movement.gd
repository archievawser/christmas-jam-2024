# first GDScript code ever, don't judge
class_name CharacterMovement
extends RigidBody2D


@export var moveSpeed: float;
@export var jumpForce: float;
@export var friction: float;
@export var cameraSpeed: float;
@export var camera: Camera2D;
@export var torso: Sprite2D;
@export var root: Node2D;

var gravity: float = 2500;
var facingRight: bool = false;
var headFacingRight: bool = false;
var velocity: Vector2;
@export var moving: bool = false;
var limbNames: Array = ["head", "arm-left", "arm-right", "leg-left", "leg-right"];
var armNames: Array = ["arm-left", "arm-right"];
var legNames: Array = ["leg-left", "leg-right"];
var legSprings: Dictionary;
var limbSockets: Dictionary;
var limbs: Dictionary;
var headFlipOffset: float;
var frameDelta: float;
var physicsDelta: float;


func _ready() -> void:
	_setup_limb_lookup();
	_build_legs();
	_update_limb_positions();

	print(legSprings);

	headFlipOffset = limbs["head"].offset.x;


func _process(delta: float) -> void:
	frameDelta = delta;

	_update_limb_positions();
	_update_camera_position();
	_update_head_rotation();

	if Input.is_action_just_pressed("jump"):
		apply_central_impulse(Vector2.UP * jumpForce);
		

func _physics_process(delta: float) -> void:
	physicsDelta = delta;

	_apply_character_movement();
	_apply_leg_friction();

	
func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	rotation = clamp(rotation, -0.1, 0.1);


func _build_legs() -> void:
	for legName in legNames:
		var physicalLeg = Spring2D.new();
		physicalLeg.body = self;
		physicalLeg.stiffness = 200;
		physicalLeg.damper = 20;
		physicalLeg.centralForce = false;
		add_child(physicalLeg);

		physicalLeg.global_position = limbSockets[legName].global_position;
		physicalLeg.target_position = Vector2(0, 55);
		
		legSprings[legName] = physicalLeg;


func _track_physical_legs() -> void:
	for legName in legNames:
		var physicalLeg: Spring2D = legSprings[legName];
		var legSprite: Sprite2D = limbs[legName];

		legSprite.global_position = physicalLeg.hitPosition;
		legSprite.rotation = physicalLeg.rotation;


func _setup_limb_lookup() -> void:
	for limbName in limbNames:
		limbs[limbName] = root.find_child(limbName);
		limbSockets[limbName] = torso.find_child(limbName + "-socket");


func _lerp_limb_to_socket(limbName, speed) -> void:
	limbs[limbName].position = lerp(limbs[limbName].position, limbSockets[limbName].global_position, speed * physicsDelta);


func _move_limb_to_socket(limbName) -> void:
	limbs[limbName].position = limbSockets[limbName].global_position;


func _update_limb_positions() -> void:
	for armName in armNames:
		_lerp_limb_to_socket(armName, 30);

	_track_physical_legs();
	_move_limb_to_socket("head");


func _apply_leg_friction() -> void:
	for legName in legNames:
		var physicalLeg: Spring2D = legSprings[legName];

		if physicalLeg.is_colliding() && !moving:
			var sliding = abs(linear_velocity.x) > 5;

			if sliding:
				physicalLeg.rotation = lerp(physicalLeg.rotation, clamp(friction * -sign(linear_velocity.x) * abs(linear_velocity.x) / 230, -1.0, 1.0), 5 * physicsDelta);
				

func _get_movement_vector() -> Vector2:
	var movementX = (1 if Input.is_action_pressed("move_right") else 0) - (1 if Input.is_action_pressed("move_left") else 0);

	return moveSpeed * physicsDelta * Vector2(movementX, 0);


func _apply_character_movement() -> void:
	var move = _get_movement_vector();

	moving = !is_zero_approx(move.length_squared());
	
	apply_central_impulse(move);


func _face_character_right() -> void:
	facingRight = true;
	torso.flip_h = true;

	limbs["arm-right"].z_index = -1;
	limbs["arm-left"].z_index = 1;

	for legName in legNames:
		limbs[legName].flip_h = true;


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

	for legName in legNames:
		limbs[legName].flip_h = false;


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
	direction.y = clamp(direction.y, -150, 150);
	direction.x = min(direction.x, -150) if direction.x < 0 else max(direction.x, 150);

	var angle = atan2(direction.y, direction.x);
	var headShouldFlip = sign(direction.x) != sign(lastHeadDirection.x);

	if headShouldFlip:
		if direction.x > 0:
			_face_character_right();
			_face_head_right();
			limbs["head"].rotation = _calculate_smart_head_rotation(angle);
		else:
			_face_character_left();
			_face_head_left();
			limbs["head"].rotation = _calculate_smart_head_rotation(angle);

	limbs["head"].rotation = _smart_radian_lerp(limbs["head"].rotation, _calculate_smart_head_rotation(angle), 10 * frameDelta);

	lastHeadDirection = direction;


func _smart_radian_lerp(a: float, b: float, t: float) -> float:
	if abs(b - a) > PI:
		if a < b:
			return lerp(a + 2 * PI, b, t);
		else:
			return lerp(a, b + 2 * PI, t);

	return lerp(a, b, t);


func _set_head_rotation(radians: float) -> void:
	limbs["head"].rotation = _calculate_smart_head_rotation(radians);


func _calculate_smart_head_rotation(radians: float) -> float:
	return radians if headFacingRight else radians - PI;


func _update_camera_position() -> void:
	camera.position = lerp(camera.position, self.position, cameraSpeed * frameDelta);
