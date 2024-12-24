class_name Bullet;
extends RigidBody2D

@export var sprite: Sprite2D;
@export var damage: float;
@export var hitSfx: AudioStreamPlayer;
const damageMat = preload("res://damage-frame.tres");
static var lastHitter: Bullet;


func _ready() -> void:
	connect("body_entered", _on_body_entered);


func _on_body_entered(body: Node):
	print("hi");
	var e := body.owner as GameManager;
	print(body.owner);
	hitSfx.play();

	damageMat.set_shader_parameter("damage_frame", true);
	lastHitter = self;
	e.damage_boss(damage);	
	sprite.visible = false;	
	collision_mask = 0;

	for i in range(2):
		await get_tree().process_frame;
			
	if lastHitter == self:
		damageMat.set_shader_parameter("damage_frame", false);

	await hitSfx.finished;
	queue_free();