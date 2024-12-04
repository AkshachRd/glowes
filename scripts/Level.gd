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
			number_of_pair_cards = 4  # Уровень 1: 4 карточки
		2:
			number_of_pair_cards = 8  # Уровень 2: 8 карточек
		3:
			number_of_pair_cards = 12  # Уровень 3: 12 карточек
		_:
			number_of_pair_cards = 4  # По умолчанию 4 карточки
	
	var card_list = []
	
	# Создаем пары карточек каждого цвета
	for card_number in range(number_of_pair_cards):
		var color = get_random_color()
		for i in range(2):
			var card_scene = preload("res://scenes/Card.tscn")
			var card = card_scene.instantiate()
			card.card_color = color
			card.connect("card_unflipped", Callable(self, "_on_Card_unflipped"))
			card.connect("card_flipped", Callable(self, "_on_Card_flipped"))
			card_list.append(card)
	
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
	if first_card.card_color == second_card.card_color:
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
	card.modulate = Color(1, 1, 1, 0)

func make_card_noninteratable(card):
	card.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)

func _on_game_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/Failed.tscn")
	
func update_timer_label():
	timer_label.text = "Время: " + str(int(time_left))
