extends Control

signal card_flipped(card)

var color
var is_flipped = false

func _ready():
	# Устанавливаем начальное состояние карточки (рубашкой вверх)
	$FrontSprite.visible = false
	$BackSprite.visible = true

func flip_up():
	is_flipped = true
	$FrontSprite.visible = true
	$BackSprite.visible = false

func flip_down():
	is_flipped = false
	$FrontSprite.visible = false
	$BackSprite.visible = true

#func _on_Card_input_event(viewport, event, shape_idx):
	#if event is InputEventMouseButton and event.pressed and not is_flipped:
		#flip_up()
		#emit_signal("card_flipped", self)
		
		
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and not is_flipped:
		flip_up()
		emit_signal("card_flipped", self)
		
#func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.pressed and not is_flipped:
		#flip_up()
		#emit_signal("card_flipped", self)
