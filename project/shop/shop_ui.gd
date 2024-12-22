class_name ShopUI;
extends Control

@export var ownedItems: Dictionary = { "pistol": true, "shotgun": false, "rifle": false };
@export var equippedItem = "pistol";
@export var equipables: Dictionary;
@export var caneCount: int;

var itemUnlockOrder = ["shotgun", "rifle"];
var itemCanes = [0, 5, 10];


func _process(delta: float) -> void:
	pass
