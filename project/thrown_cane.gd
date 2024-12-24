class_name ThrownCane;
extends RigidBody2D

var snowman;
var first_physics_process = true;
var player;
@export var normalSprite: Sprite2D;
@export var interactableSprite: Sprite2D;
static var t = 0.0;
static var lastDeflect = 0.0;
var deflected = false;




func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var dir = linear_velocity.normalized();
	rotation = atan2(dir.y, dir.x);


var lastDist = 0.0;
func _process(delta: float) -> void:
	t += delta;
	var interactDist = 600;
	var offset = (player.global_position - global_position);
	var dist = (player.global_position - global_position).length();

	if !deflected && dist < interactDist:
		if lastDist > interactDist:
			interactableSprite.visible = true;
			normalSprite.visible = false;

		if !deflected && t - lastDeflect > 0.05 && Input.is_action_just_pressed("deflect"):
			if sign(offset.y) == 1:
				linear_velocity = Vector2(-1000, -1000);
			else:
				linear_velocity = Vector2(-1000, 1000);

			player.linear_velocity.x += 1000;
			deflected = true;
			
		if dist < 130:
			player.linear_velocity /= 2;
			queue_free();

	elif deflected || lastDist < interactDist:
		interactableSprite.visible = false;
		normalSprite.visible = true;

	lastDist = dist;
