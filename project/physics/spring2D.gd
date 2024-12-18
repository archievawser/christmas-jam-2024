class_name Spring2D;
extends RayCast2D;


@export var body: RigidBody2D;
@export var stiffness: float;
@export var damper: float;
@export var centralForce: bool;
var length: float;
var previousLength: float;
var hitPosition: Vector2;


func _init() -> void:
	pass;


func _ready() -> void:
	length = target_position.length();
	previousLength = length;


func _physics_process(dt: float) -> void:
	if is_colliding():	
		hitPosition = get_collision_point();
		var springDirection = global_position - get_collision_point();
		var distance = springDirection.length(); 
		var impulse = springDirection.normalized() * _calculate_spring_impulse_magnitude(distance, dt);

		if centralForce:
			body.apply_central_impulse(impulse * dt);
		else:
			body.apply_impulse(impulse * dt, self.position);
		
		previousLength = distance;
	else:
		hitPosition = global_position + target_position;


# Hooke's law
func _calculate_spring_impulse_magnitude(currentLength: float, dt: float) -> float:
	var stiffnessForce = -stiffness * (currentLength - length);
	var damperForce = damper * (previousLength - currentLength) / dt;

	return damperForce + stiffnessForce;
