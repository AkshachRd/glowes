extends Control

signal card_flipped(card)
signal card_unflipped(card)

var card_color = Color.WHITE
var is_flipped = false

@onready var front_sprite = find_child("FrontSprite")
@onready var animation_player = find_child("AnimationPlayer")

func _ready():
	front_sprite.modulate = card_color
	is_flipped = false

func flip_up():
	is_flipped = true
	animation_player.play("card_flip_up")

func flip_down():
	is_flipped = false
	animation_player.play("card_flip_down")

func make_invisible():
	animation_player.play("make_invisible")

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if is_flipped:
			flip_down()
			emit_signal("card_unflipped", self)
		else:
			flip_up()
			emit_signal("card_flipped", self)
		
