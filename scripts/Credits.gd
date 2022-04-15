extends PanelContainer

const DEFAULT_SPEED = 50.0
const FAST_SPEED = 300.0

onready var scroll_container = $ScrollContainer
onready var vscroll = scroll_container.get_v_scrollbar()


func _ready():
	var label: Label = $ScrollContainer/VBoxContainer/Names

	# todo credits in editor check exists in two places - should be simiplied to one utility function
	# Credits file is generated at build time - use placeholder string if in editor
	if OS.has_feature("editor"):
		var sample_names: Array = ["Mario Mario", "Luigi Mario", "Baby Mario"]
		var names_text: String = ""

		for n in 100:
			for i in range(0, sample_names.size()):
				names_text += sample_names[i] + "\n"

		label.text = names_text
		return

	var file = File.new()
	var err = file.open("res://credits.txt", File.READ)
	if err != OK:
		print("Couldn't load credits.txt. The file might be missing.")
		return
	label.text = file.get_as_text()


func _process(delta):
	if Input.is_action_pressed("jump"):
		vscroll.value += delta * FAST_SPEED
	else:
		vscroll.value += delta * DEFAULT_SPEED

	if (
		vscroll.value >= vscroll.max_value - scroll_container.rect_size.y
		|| Input.is_action_pressed("pause")
	):
		EventBus.emit_signal("change_scene", {"scene": "res://scenes/title/TitleScreen.tscn"})