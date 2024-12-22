extends Node2D

@export var shop: ShopUI;
@export var player: CharacterMovement;
@export var snowman: RigidBody2D;


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	snowman.position += Vector2(1900, 0) * delta;
