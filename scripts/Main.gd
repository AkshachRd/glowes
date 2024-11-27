extends Node

var first_card = null
var second_card = null
var grid_container = null
var can_flip = true

func _ready():
	var center_container = CenterContainer.new()
	# Создаём GridContainer и настраиваем его
	grid_container = GridContainer.new()
	grid_container.columns = 4  # Установите нужное количество столбцов
	# Настройка отступов между элементами
	grid_container.add_theme_constant_override("h_separation", 10)  # горизонтальный отступ
	grid_container.add_theme_constant_override("v_separation", 10)  # вертикальный отступ
	# Создаём карточки в контейнере
	create_cards(grid_container)
	center_container.add_child(grid_container)
	add_child(center_container)

func create_cards(container):
	var colors = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW]
	var card_list = []
	
	# Создаем пары карточек каждого цвета
	for color in colors:
		for i in range(2):
			var card_scene = preload("res://scenes/Card.tscn")
			var card = card_scene.instantiate()
			card.color = color
			card.get_node("FrontSprite").modulate = color  # Задаем цвет лицевой стороны
			card.connect("card_flipped", Callable(self, "_on_Card_flipped"))
			card_list.append(card)
	
	# Перемешиваем карточки
	card_list.shuffle()
	
	# Добавляем карточки в контейнер
	for card in card_list:
		container.add_child(card)

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
		print(grid_container.get_child_count())
		if grid_container.get_child_count() == 2:
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
