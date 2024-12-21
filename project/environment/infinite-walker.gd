class_name InfiniteWalker;
extends Node2D;

@export var cam: Camera2D;
@export var firstCollider: CollisionShape2D;
@export var firstSprite: Sprite2D;
@export var secondCollider: CollisionShape2D;
@export var secondSprite: Sprite2D;
var sprites;
var colliders;


func _ready() -> void:
	sprites = [ firstSprite, secondSprite ]
	colliders = [ firstCollider, secondCollider ]
	
	print(sprites);


func _process(delta: float) -> void:
	var camSize = cam.get_viewport_rect().size;
	var camLeftBound = cam.global_position.x - camSize.x;
	var camRightBound = cam.global_position.x + camSize.x;
	
	for i in range(sprites.size()):
		var collider: CollisionShape2D = colliders[i];
		var sprite: Sprite2D = sprites[i];
		var spriteSize = sprite.get_rect().size * sprite.scale;
		var spriteRightBound = sprite.global_position.x + spriteSize.x / 2;
		var spriteLeftBound = sprite.global_position.x - spriteSize.x / 2;

		if spriteRightBound < camLeftBound:
			sprite.global_position.x += spriteSize.x * 2 - 5;
			collider.global_position.x += spriteSize.x * 2 - 5;
		elif spriteLeftBound > camRightBound:
			sprite.global_position.x -= spriteSize.x * 2 - 5;
			collider.global_position.x -= spriteSize.x * 2 - 5;
