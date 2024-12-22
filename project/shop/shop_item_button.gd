extends Control

@export var text: String;
@export var caneLabel: Label;
@export var button: Panel;
@export var requiredCanes: int;
@export var itemId: String;
var hovering = false;


func _ready() -> void:
	caneLabel.text = text;
	button.connect("mouse_entered", _on_hover);
	button.connect("mouse_exited", _on_exit);


func _process(delta: float) -> void:
	if hovering && Input.is_action_just_released("activate"):
		_attempt_purchase();


func _attempt_purchase() -> void:
	var shop: ShopUI = owner;

	if shop.caneCount > requiredCanes:
		shop.ownedItems[itemId] = true;
		shop.equippedItem = itemId;


func _set_required_canes(amt: int) -> void:
	caneLabel.text = "NEED " + str(amt) + " CANES";
	requiredCanes = amt;


func _on_hover() -> void:
	hovering = true;


func _on_exit() -> void:
	hovering = false;
