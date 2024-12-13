extends Node

var selected_level = 1  # По умолчанию уровень 1
var number_of_pair_cards = 4  # Количество карточек по умолчанию
var time_left = 60  # Изначальное время в секундах

var first_card = null
var second_card = null
var grid_container = null
var can_flip = true

@onready var grid = find_child("GridContainer")
@onready var timer_label = find_child("TimerLabel")

func _ready():
	selected_level = Global.selected_level
	grid.columns = _get_columns()
	create_cards()
	# Запускаем таймер
	$GameTimer.start()
	# Инициализируем отображение времени
	update_timer_label()

func _process(delta: float) -> void:
	time_left = $GameTimer.get_time_left()
	update_timer_label()

func create_cards():
	match selected_level:
		1:
			number_of_pair_cards = 3  # Уровень 1: 4 карточки
		2:
			number_of_pair_cards = 4  # Уровень 2: 8 карточек
		3:
			number_of_pair_cards = 6  # Уровень 3: 12 карточек
		_:
			number_of_pair_cards = 2  # По умолчанию 4 карточки
	
	var card_list = []
	
	# Создаем пары карточек каждого цвета
	for card_number in range(number_of_pair_cards):
		for i in range(2):
			var card_scene = preload("res://scenes/Card.tscn")
			var card = card_scene.instantiate()
			card.connect("card_unflipped", Callable(self, "_on_Card_unflipped"))
			card.connect("card_flipped", Callable(self, "_on_Card_flipped"))
			card_list.append(card)
	
	assign_backs_to_cards(card_list)
	assign_gloves_to_cards(card_list)
	assign_colors_to_cards(card_list)
	# Перемешиваем карточки
	card_list.shuffle()
	
	# Добавляем карточки в контейнер
	for card in card_list:
		grid.add_child(card)

func _on_Card_unflipped(card):
	can_flip = true
	first_card = null
	second_card =  null

func _on_Card_flipped(card):
	if not can_flip:
		return
	if first_card == null:
		first_card = card
	elif second_card == null and card != first_card:
		second_card = card
		can_flip = false
		# Проверяем совпадение после небольшой задержки
		check_match()

func check_match():
	await get_tree().create_timer(0.5).timeout
	if first_card.variant == second_card.variant:
		# Убираем совпавшие карточки
		number_of_pair_cards -= 1
		make_card_invisible(first_card)
		make_card_invisible(second_card)
		make_card_noninteratable(first_card)
		make_card_noninteratable(second_card)
		# Проверяем, остались ли карточки
		if number_of_pair_cards == 0:
			level_complete()
	else:
		# Переворачиваем карточки обратно
		first_card.flip_down()
		second_card.flip_down()
	# Сбрасываем выбранные карточки
	first_card = null
	second_card = null
	can_flip = true

func level_complete():
	get_tree().change_scene_to_file("res://scenes/Completed.tscn")

# Function to generate a random color
func get_random_color():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	rng.randi_range(0, 1)
	return Color(rng.randi_range(0, 1), rng.randi_range(0, 1), rng.randi_range(0, 1))

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
	
func make_card_invisible(card):
	card.make_invisible()

func make_card_noninteratable(card):
	card.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

func _on_game_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/Failed.tscn")
	
func update_timer_label():
	timer_label.text = "Время: " + str(int(time_left))
	
func _get_columns():
	match selected_level:
		1:
			return 2  # Уровень 1: 4 карточки
		2:
			return 3  # Уровень 2: 8 карточек
		3:
			return 3  # Уровень 3: 12 карточек
		_:
			return 2  # По умолчанию 4 карточки
			
const number_of_gloves_variants = 6

func assign_gloves_to_cards(cards):
	var variant = 1
	var variants_path = "res://assets/gloves_variants/"
	
	var card_number = 0
	while card_number < cards.size() - 1:
		var path = variants_path + str(variant)
		var left_texture = load(path + "/Left.svg")
		var right_texture = load(path + "/Right.svg")
		
		var left_card = cards[card_number]
		left_card.glove = left_texture
		left_card.variant = variant
		
		card_number += 1
		var right_card = cards[card_number]
		right_card.glove = right_texture
		right_card.variant = variant
		
		variant += 1
		
		if variant > number_of_gloves_variants:
			variant = 1
			
		card_number += 1
		
func assign_colors_to_cards(cards):
	var card_number = 0
	while card_number < cards.size() - 1:
		var color = get_random_color()
		
		var card = cards[card_number]
		card.card_color = color
		
		card_number += 1
		card = cards[card_number]
		card.card_color = color
		
		card_number += 1
		
func assign_backs_to_cards(cards):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var back_variant = rng.randi_range(1, 3)
	
	var variants_path = "res://assets/card/backs/"
	var path = variants_path + str(back_variant) + ".png"
	var back_texture = load(path)
	
	for card in cards:
		card.back = back_texture
	
