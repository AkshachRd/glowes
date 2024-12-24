extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Level.tscn")

func _on_next_pressed() -> void:
	Global.selected_level += 1
	get_tree().change_scene_to_file("res://scenes/Level.tscn")
