extends Control

signal card_flipped(card)
signal card_unflipped(card)

var card_color = Color.WHITE
var is_flipped = false

# Reference to the FrontSprite node
@onready var front_sprite = $FrontSprite

func _ready():
	# Устанавливаем начальное состояние карточки (рубашкой вверх)
	front_sprite.modulate = card_color
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

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if is_flipped:
			flip_down()
			emit_signal("card_unflipped", self)
		else:
			flip_up()
			emit_signal("card_flipped", self)
		
