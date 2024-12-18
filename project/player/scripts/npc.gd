class_name NPC;
extends CharacterMovement;


func _apply_character_movement() -> Vector2:
	return Vector2();


func _can_jump() -> bool:
	return false;


func _update_head_rotation() -> void:
	pass;