class_name Spring2D;
extends RayCast2D;


@export var otherBody: RigidBody2D;
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
	if _should_apply_spring_force():	
		hitPosition = _get_current_spring_position();
		var springDirection = _get_spring_direction();
		var distance = springDirection.length(); 
		var impulse = springDirection.normalized() * _calculate_spring_impulse_magnitude(distance, dt);

		if otherBody:
			impulse /= 2;

		if centralForce:
			body.apply_central_impulse(impulse * dt);

			if otherBody:
				otherBody.apply_central_impulse(-impulse * dt);
		else:
			body.apply_impulse(impulse * dt, self.position);

			if otherBody:
				otherBody.apply_impulse(-impulse * dt, self.position);
		
		previousLength = distance;
	else:
		hitPosition = global_position + target_position;


func _should_apply_spring_force() -> bool:
	return is_colliding();


func _get_spring_direction() -> Vector2:
	return global_position - hitPosition;


func _get_current_spring_position() -> Vector2:
	return get_collision_point();


# Hooke's law
func _calculate_spring_impulse_magnitude(currentLength: float, dt: float) -> float:
	var stiffnessForce = -stiffness * (currentLength - length);
	var damperForce = damper * (previousLength - currentLength) / dt;

	return damperForce + stiffnessForce;
