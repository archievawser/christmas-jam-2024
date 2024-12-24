class_name Cart;
extends RigidBody2D;

@export var head: Sprite2D;
@export var plr: RigidBody2D;
@export var armSocket: Node2D;
@export var cane = preload("res://items/thrown_cane.tscn");
var lastDelta = 0.0;


func _process(delta: float) -> void:
	var dir = (head.global_position - plr.global_position).normalized();
	var angle = atan2(dir.y, dir.x);
	head.rotation = angle;
	lastDelta = delta;


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var start = 0;
	var goal = 2000;
	
	#print((owner.playTime - owner.timeLeftSeconds));
	#global_position += (Vector2(lerp(start, goal, clamp((owner.playTime - owner.timeLeftSeconds) / 3, 0, 1)), 0) * lastDelta);
