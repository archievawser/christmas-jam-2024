extends Control

@export var caneLabel: Label;
@export var button: Panel;
@export var requiredCanes: int;


func _ready() -> void:
	button.connect("mouse_entered", _attempt_purchase);


func _set_required_canes(amt: int) -> void:
	caneLabel.text = "NEED " + str(amt) + " CANES";
	requiredCanes = amt;


func _attempt_purchase() -> void:
	print("tried to buy");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
