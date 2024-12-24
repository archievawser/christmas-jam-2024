class_name Dialog;
extends TextureRect

@export var labels: Array;
@export var texts: Array;
@export var typeSfx: AudioStreamPlayer;
static var busy = false;
var i = 0;

func _ready() -> void:
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible && !busy && Input.is_action_just_released("next"):
		print(i);
		print(labels);
		if i >= labels.size():
			busy = false;
			_on_finish();
			return;
			
		busy = true;

		var label = get_node(labels[i]);
		var text: String = texts[i];

		label.text = "";

		for j in range(len(text)):
			var c = text[j];
			label.text += c;
			typeSfx.play();
			await get_tree().create_timer(0.03).timeout;

		i += 1;
		busy = false;


func _on_finish() -> void:
	queue_free();
	owner.start_game();
