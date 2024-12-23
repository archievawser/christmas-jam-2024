class_name Bullet;
extends RigidBody2D

@export var sprite: Sprite2D;
@export var damage: float;


func _ready() -> void:
	connect("body_entered", _on_body_entered);


func _on_body_entered(body: Node):
	print("hi");
	var e := body.owner as GameManager;
	print(body.owner);

	e.damage_boss(damage);

	queue_free();
