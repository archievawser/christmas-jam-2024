class_name Equipable;
extends Node2D

@export var sprite: Sprite2D;
@export var weakHandGrip: Node2D;
@export var dominantHandGrip: Node2D;
@export var body: RigidBody2D;
@export var facingLeft: bool;


func activate() -> void:
	pass;


func deactivate() -> void:
	pass;
	

func flip() -> void:
	facingLeft = !facingLeft;
	sprite.flip_h = facingLeft;

	if weakHandGrip:
		weakHandGrip.position.x = abs(weakHandGrip.position.x) * (-1 if facingLeft else 1);
	
	if dominantHandGrip:
		dominantHandGrip.position.x = abs(dominantHandGrip.position.x) * (-1 if facingLeft else 1);

	sprite.position.x = abs(sprite.position.x) * (1 if facingLeft else -1);


func aim_at(target: Vector2) -> void:
	var offset = body.global_position - target;
	var angle = atan2(offset.y, offset.x);
	
	if facingLeft:
		angle += PI;
	
	body.rotation = angle;


# true = right, false = left
func set_look_direction(direction: bool) -> void:
	if facingLeft != direction:
		flip();