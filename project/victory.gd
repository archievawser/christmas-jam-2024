# im tired boss
extends Dialog
@export var otherLabel: Control;


var lastVisible = false;
func _process(delta: float) -> void:
	if lastVisible != visible:
		owner.end_game();

	lastVisible = visible;

	super(delta);


func _on_finish() -> void:
	otherLabel.visible = false;
	pass;
