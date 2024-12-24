extends Dialog
@export var otherLabel: Control;


var lastVisible = false;
func _process(delta: float) -> void:
	if visible && !lastVisible:
		owner.end_game();

	lastVisible = visible;

	super(delta);


func _on_finish() -> void:
	owner.start_game();
	visible = false;