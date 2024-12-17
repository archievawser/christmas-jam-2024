class_name Spring2D;
extends RayCast2D;


@export var body: RigidBody2D;
@export var stiffness: float;
@export var damper: float;
@export var centralForce: bool;
var length: float;
var previousLength: float;


func _ready() -> void:
	length = target_position.length();
	previousLength = length;


func _process(dt: float) -> void:
	var springDirection = global_position - get_collision_point();
	var distance = springDirection.length(); 
	var impulse = springDirection.normalized() * _calculate_spring_impulse_magnitude(distance, dt);
	
	if is_colliding():
		if centralForce:
			body.apply_central_impulse(impulse * dt);
		else:
			body.apply_impulse(impulse * dt, self.position);
		
		previousLength = distance;


# Hooke's law
func _calculate_spring_impulse_magnitude(currentLength: float, dt: float) -> float:
	var stiffnessForce = -stiffness * (currentLength - length);
	var damperForce = damper * (previousLength - currentLength) / dt;

	return damperForce + stiffnessForce;
