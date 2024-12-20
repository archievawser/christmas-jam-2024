class_name ArmSpring2D;
extends Spring2D;


func _get_current_spring_position() -> Vector2:
	return body.global_position;


func _get_spring_direction() -> Vector2:
	return hitPosition - global_position;


func _should_apply_spring_force() -> bool:
	return true;