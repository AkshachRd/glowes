extends Control

var selected_level = 1  # Переменная для хранения выбранного уровня

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected_level = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_level_button_1_pressed() -> void:
	selected_level = 1
	start_game()

func _on_level_button_2_pressed() -> void:
	selected_level = 2
	start_game()

func _on_level_button_3_pressed() -> void:
	selected_level = 3
	start_game()

func start_game():
	# Сохраним выбранный уровень в глобальной переменной или через автозагрузку
	Global.selected_level = selected_level
	# Перейдем на игровую сцену
	get_tree().change_scene_to_file("res://scenes/Level.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
