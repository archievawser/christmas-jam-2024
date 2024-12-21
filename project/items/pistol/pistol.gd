class_name Pistol;
extends Equipable;

@export var shootStream: AudioStreamPlayer2D;
@export var recoilPower: float = 15000;
@export var bulletSpeed: float = 1000;
@export var barrelSocket: Node2D;
var bulletPreset = preload("res://items/bullet/bullet.tscn")


func activate() -> void:
	shootStream.play();
	body.apply_central_impulse(body.transform.x * recoilPower * (-1.0 if facingLeft else 1.0));

	var bulletDir = (aimingAt - barrelSocket.global_position).normalized();
	var bulletImpulse = bulletDir * bulletSpeed;
	var bullet: Bullet = bulletPreset.instantiate();
	add_child(bullet);
	bullet.global_position = barrelSocket.global_position;
	bullet.apply_central_impulse(bulletImpulse);
	bullet.rotation = atan2(bulletDir.y, bulletDir.x);
