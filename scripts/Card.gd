extends Control

signal card_flipped(card)
signal card_unflipped(card)

var card_color = Color.BLACK
var variant = null
var back = preload("res://assets/card/backs/1.png")
var glove = preload("res://assets/gloves_variants/1/Left.svg")
var is_flipped = false

@onready var front_sprite = find_child("FrontSprite")
@onready var back_sprite = find_child("BackSprite")
@onready var background_node = find_child("Background")
@onready var glove_node = find_child("Glove")
@onready var animation_player = find_child("AnimationPlayer")

func _ready():
	_set_glove_image()
	back_sprite.texture = back
	background_node.modulate = card_color
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

func _set_glove_image():
	glove_node.texture = glove
	
