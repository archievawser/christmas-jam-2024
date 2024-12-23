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

var healthBarMax = 383;
var maxBossHp = 500;
var bossHp = maxBossHp;
var playTime = 30;
var playing = false;
var playerStartPos;
var snowmanStartPos;
var timeLeftSeconds: float;
var timeSinceSnowmanOffscreen: float;
var maxSnowmanOffTime = 10.45;
var wasSnowmanOffscreenLastFrame = false;


func _ready() -> void:
	playerStartPos = player.global_position;
	snowmanStartPos = snowman.global_position;
	timeLeftSeconds = playTime;

	start_game();


var lastTimeRoundedTimeLeft;
func _process(delta: float) -> void:

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
	else:
		timer.visible = false;

	wasSnowmanOffscreenLastFrame = camRightBound < snowmanLeftBound.global_position.x;

	if playing:
		if roundf(timeSinceSnowmanOffscreen) != lastTimeRoundedTimeLeft:
			timerNotification.play();

		var start = 0;
		var goal = 2000;
	
		snowman.position += Vector2(lerp(start, goal, clamp((playTime - timeLeftSeconds) / 3, 0, 1)), 0) * delta;


func damage_boss(dmg: float) -> void:
	_set_boss_health(bossHp - dmg);


func _set_boss_health(hp: float) -> void:
	bossHp = hp;

	healthBar.size.x = lerp(0, healthBarMax, bossHp / maxBossHp);


func check_end_game() -> void:
	if false:#timeSinceSnowmanOffscreen >= maxSnowmanOffTime:
		player.global_position = playerStartPos;
		snowman.global_position = snowmanStartPos;
		player.linear_velocity = Vector2();

		end_game();


func start_game() -> void:
	timeLeftSeconds = playTime;
	shop.visible = false;
	playing = true;

	# gameplayTheme.play();


func end_game() -> void:
	shop.visible = true;
	playing = false;