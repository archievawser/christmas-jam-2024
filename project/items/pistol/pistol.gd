class_name Pistol;
extends Equipable;

@export var shootStream: AudioStreamPlayer2D;
@export var recoilPower: float = 15000;


func activate() -> void:
	shootStream.play();
	body.apply_central_impulse(body.transform.x * recoilPower * (-1.0 if facingLeft else 1.0));
