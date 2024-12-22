class_name InfiniteWalker;
extends Node2D;

@export var cam: Camera2D;
@export var environment: RigidBody2D
@export var firstCollider: CollisionShape2D;
@export var firstSprite: Sprite2D;
@export var secondCollider: CollisionShape2D;
@export var secondSprite: Sprite2D;
var basicObstacles = [ preload("res://environment/basic_obstacle.tscn"), preload("res://environment/tower_obstacle.tscn") ];
var rng = RandomNumberGenerator.new();
var sprites;
var colliders;
var obstacles = [];
var lastCamPos: Vector2;


func _ready() -> void:
	rng.randomize();
	sprites = [ firstSprite, secondSprite ]
	colliders = [ firstCollider, secondCollider ]
	lastCamPos = cam.global_position;


func _process(delta: float) -> void:
	var camSize = cam.get_viewport_rect().size;
	var camLeftBound = (cam.global_position + cam.offset).x - camSize.x;
	var camRightBound = camLeftBound + camSize.x * 2;

	var camDelta = cam.global_position - lastCamPos;

	for i in range(sprites.size()):
		var collider: CollisionShape2D = colliders[i];
		var sprite: Sprite2D = sprites[i];
		var spriteSize = sprite.get_rect().size * sprite.scale;
		var spriteLeftBound = (sprite.global_position + sprite.offset).x - spriteSize.x / 2;
		var spriteRightBound = spriteLeftBound + spriteSize.x;

		# move the sprite to the right of the cam
		if camDelta.x > 0 && spriteRightBound < camLeftBound:
			sprite.global_position.x += spriteSize.x * 2;
			collider.global_position.x += spriteSize.x * 2;
			_process_basic_obstacles(sprite.global_position.x + spriteSize.x / 2, spriteSize.x);

		# move the sprite to the left of the cam
		elif camDelta.x < 0 && spriteLeftBound > camRightBound:
			sprite.global_position.x -= spriteSize.x * 2;
			collider.global_position.x -= spriteSize.x * 2;

	lastCamPos = cam.global_position;


func _process_basic_obstacles(start: float, span: float) -> void:
	var shouldGenerateObstacle = rng.randi_range(0, 2) == 0;

	if shouldGenerateObstacle:
		var newObstacle: Obstacle = basicObstacles[rng.randi_range(0, 1)].instantiate();
		var index = rng.randi_range(3, int(span / newObstacle.span));
		var pos = start + newObstacle.span * index;

		newObstacle.global_position = Vector2(pos, newObstacle.spawnHeight);
		environment.add_child(newObstacle);