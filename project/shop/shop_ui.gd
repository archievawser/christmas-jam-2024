class_name ShopUI;
extends Control

@export var ownedItems: Dictionary = { "pistol": true, "shotgun": false, "rifle": false };
@export var equippedItem = "pistol";
@export var equipables: Dictionary;
@export var caneCount: int;
@export var tryAgainBtn: Control;


var itemUnlockOrder = ["shotgun", "rifle"];
var itemCanes = [0, 5, 10];


var tryAgainHovered = false;

func _ready() -> void:
	tryAgainBtn.connect("mouse_entered", hoverTryAgain);
	tryAgainBtn.connect("mouse_exited", exitTryAgain);


func hoverTryAgain() -> void:
	tryAgainHovered = true;


func exitTryAgain() -> void:
	tryAgainHovered = false;


func _process(delta: float) -> void:
	if Input.is_action_just_released("activate"):
		if tryAgainHovered:
			var game := owner as GameManager;
			
			game.start_game();
