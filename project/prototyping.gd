class_name GameManager;
extends Node2D

@export var shop: ShopUI;
@export var player: RigidBody2D;
@export var snowman: RigidBody2D;
@export var snowmanLeftBound: Node2D;
@export var gunItems: Dictionary;
@export var timer: Label;
@export var healthBar: Control;
@export var gameplayTheme: AudioStreamPlayer;
@export var cam: Camera2D;
@export var timerNotification: AudioStreamPlayer;
@export var failed: Control;
@export var victory: Control;

var healthBarMax = 383;
var maxBossHp = 500;
var bossHp = maxBossHp;
var playTime = 30;
var playing = false;
var playerStartPos;
var snowmanStartPos;
var timeLeftSeconds: float;
var timeSinceSnowmanOffscreen: float;
var maxSnowmanOffTime = 14.49;
var wasSnowmanOffscreenLastFrame = false;
var cane = preload("res://items/thrown_cane.tscn");
var rng = RandomNumberGenerator.new();


func _ready() -> void:
	playerStartPos = player.global_position;
	snowmanStartPos = snowman.global_position;
	timeLeftSeconds = playTime;
	

var lastAttackTime = 0.0;
var nextAttackCooldown = 3.0;
var lastTimeRoundedTimeLeft;
func _process(delta: float) -> void:
	var time = playTime - timeLeftSeconds;
	lastTimeRoundedTimeLeft = roundf(timeSinceSnowmanOffscreen);
	timeLeftSeconds -= delta;
	
	var camSize = cam.get_viewport_rect().size;
	var camLeftBound = (cam.global_position + cam.offset).x - camSize.x;
	var camRightBound = camLeftBound + camSize.x * 2;

	if camRightBound < snowmanLeftBound.global_position.x:
		if !wasSnowmanOffscreenLastFrame:
			timeSinceSnowmanOffscreen = 0;

		timeSinceSnowmanOffscreen += delta;
		timer.visible = true;
		timer.text = str(roundf(maxSnowmanOffTime - timeSinceSnowmanOffscreen));

		if timeSinceSnowmanOffscreen > maxSnowmanOffTime:
			failed.visible = true;
	else:
		timer.visible = false;

	wasSnowmanOffscreenLastFrame = camRightBound < snowmanLeftBound.global_position.x;

	if playing:
		if time < 1:
			cam.position.y = lerp(1200, 100, time / 1);

		if roundf(timeSinceSnowmanOffscreen) != lastTimeRoundedTimeLeft:
			timerNotification.play();

		var start = 0;
		var goal = 2000;

		if time - lastAttackTime > nextAttackCooldown:
			throw_cane();

			if bossHp < maxBossHp / 4:
				nextAttackCooldown = rng.randf_range(0.2, 1);
			else:
				nextAttackCooldown = rng.randf_range(0.2, 2);

			lastAttackTime = time;
	
		snowman.move_and_collide(Vector2(lerp(start, goal, clamp((playTime - timeLeftSeconds) / 7, 0, 1)), 0) * delta);

var canes = [];


func throw_cane() -> void:
	print("throwing");
	var newCane = cane.instantiate();
	newCane.snowman = snowman;
	newCane.player = player;
	newCane.global_position = snowman.armSocket.global_position;
	
	var dist = (player.global_position - newCane.global_position).length();
	var speed = lerp(1000, 2000, 1 - bossHp / maxBossHp);
	var dir = ((player.global_position + player.linear_velocity / 5) - newCane.global_position).normalized();
	newCane.linear_velocity = dir * speed;
	
	add_child(newCane);
	canes.append(newCane);


func damage_boss(dmg: float) -> void:
	_set_boss_health(bossHp - dmg);


func _set_boss_health(hp: float) -> void:
	bossHp = hp;

	healthBar.size.x = lerp(0, healthBarMax, bossHp / maxBossHp);

	if bossHp <= 0:
		victory.visible = true;


func check_end_game() -> void:
	if timeSinceSnowmanOffscreen >= maxSnowmanOffTime:
		timeSinceSnowmanOffscreen = 0;
		player.global_position = playerStartPos;
		snowman.global_position = snowmanStartPos;
		player.linear_velocity = Vector2();
		bossHp = maxBossHp;

		end_game();


func start_game() -> void:
	timeLeftSeconds = playTime;
	shop.visible = false;
	lastAttackTime = 0.0;
	playing = true;
	gameplayTheme.play();


func end_game() -> void:
	for v in canes:
		if is_instance_valid(v):
			v.queue_free();
		else:
			canes.erase(v);
	
	gameplayTheme.stop();
	playing = false;