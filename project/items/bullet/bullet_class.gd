class_name Bullet;
extends RigidBody2D

@export var sprite: Sprite2D;
@export var damage: float;


func _ready() -> void:
	print("created");
	connect("body_entered", _on_body_entered);


func _on_body_entered(body: Node):
	var npc := body as NPC;

	if npc:
		print("hit ", npc)
		npc.take_damage(damage);

	queue_free();
