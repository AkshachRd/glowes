extends GridContainer

var first_card = null
var second_card = null
var can_flip = true

func _ready():
	create_cards()

func create_cards():
	var colors = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW]
	var card_list = []
	var start_position = Vector2(100, 100)  # Начальная позиция для первой карточки
	var horizontal_offset = Vector2(0, 0)
	var card_spacing = 200  # Отступ между карточками по оси X
	
	# Создаем пары карточек каждого цвета
	for color in colors:
		horizontal_offset = horizontal_offset + Vector2(card_spacing, 0)
		for i in range(2):
			var card_scene = preload("res://scenes/Card.tscn")
			var card = card_scene.instantiate()
			card.color = color
			card.position = start_position + Vector2(0, 1.5 * card_spacing * i) + horizontal_offset
			card.get_node("FrontSprite").modulate = color  # Задаем цвет лицевой стороны
			card.connect("card_flipped", Callable(self, "_on_Card_flipped"))
			card_list.append(card)
	
	# Перемешиваем карточки
	card_list.shuffle()
	
	# Добавляем карточки в контейнер
	for card in card_list:
		add_child(card)

func _on_Card_flipped(card):
	if not can_flip:
		return
	if first_card == null:
		first_card = card
	elif second_card == null and card != first_card:
		second_card = card
		can_flip = false
		# Проверяем совпадение после небольшой задержки
		get_tree().create_timer(1.0)
		check_match()

func check_match():
	if first_card.color == second_card.color:
		# Убираем совпавшие карточки
		first_card.queue_free()
		second_card.queue_free()
		# Проверяем, остались ли карточки
		if get_child_count() == 2:
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
