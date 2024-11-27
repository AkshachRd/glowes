extends Node

var selected_level = 1  # По умолчанию уровень 1

var first_card = null
var second_card = null
var grid_container = null
var can_flip = true

@onready var grid = get_node("GridContainer")

func _ready():
	selected_level = Global.selected_level
	create_cards()

func create_cards():
	var number_of_pair_cards = 4  # Количество карточек по умолчанию
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
		first_card.queue_free()
		second_card.queue_free()
		# Проверяем, остались ли карточки
		if grid.get_child_count() == 2:
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
	print("Уровень пройден!")
	# Вы можете добавить здесь переход на следующий уровень или конец игры

# Function to generate a random color
func get_random_color():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return Color(rng.randf(), rng.randf(), rng.randf())
