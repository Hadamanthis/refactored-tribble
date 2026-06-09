extends Control

signal money_changed(new_value: int)
signal reputation_changed(new_value: int)
signal game_lost(reason: String)

const STARTING_REPUTATION := 5
const MAX_REPUTATION := 5

enum FeedbackType {
	INFO,
	SUCCESS,
	WARNING,
	ERROR
}

@export var available_ingredients: Array[IngredientData] = []
@export var available_customers: Array[CustomerData] = []

@onready var money_label: Label = %MoneyLabel
@onready var reputation_label: Label = %ReputationLabel

@onready var cauldron: Cauldron = %Cauldron
@onready var customer: Customer = %Customer

@onready var customer_panel: CustomerView = %CustomerPanel
@onready var cauldron_button: Button = %CauldronButton
@onready var cauldron_vision: TextureRect = %CauldronVision
@onready var potion_button: Button = $PotionButton

@onready var cauldron_ingredients_label: Label = %CauldronIngredientsLabel
@onready var result_label: Label = %ResultLabel
@onready var result_panel: PanelContainer = %ResultPanel

@onready var herb_card: IngredientCard = %HerbCard
@onready var lavender_card: IngredientCard = %LavenderCard
@onready var pepper_card: IngredientCard = %PepperCard

@onready var mix_button: Button = %MixButton
@onready var deliver_button: Button = %DeliverButton
@onready var clear_button: Button = %ClearButton
@onready var restart_button: Button = %RestartButton

var ingredient_by_id: Dictionary = {}
var current_customer: CustomerData

var served_customers_count: int = 0
var money := 0
var reputation := STARTING_REPUTATION

var is_game_over := false

func _ready() -> void:
	build_ingredient_lookup()
	
	money_changed.connect(_on_money_changed)
	reputation_changed.connect(_on_reputation_changed)
	
	cauldron.ingredients_changed.connect(_on_cauldron_ingredients_changed)
	cauldron.potion_mixed.connect(_on_cauldron_potion_mixed)
	cauldron.cauldron_cleared.connect(_on_cauldron_cleared)
	
	customer.patience_changed.connect(customer_panel.set_patience_ratio)
	customer.patience_depleted.connect(_on_customer_patience_depleted)
	
	herb_card.ingredient_selected.connect(_on_ingredient_selected)
	lavender_card.ingredient_selected.connect(_on_ingredient_selected)
	pepper_card.ingredient_selected.connect(_on_ingredient_selected)
	
	update_hud()
	pick_next_customer()
	update_cauldron_label()
	update_buttons()
	update_result_panel(FeedbackType.INFO)

func try_add_ingredient(ingredient_id: String) -> void:
	if cauldron.state == Cauldron.State.POTION_READY:
		show_result("A poção já foi misturada.", FeedbackType.WARNING)
		return
	
	if cauldron.is_full():
		show_result("O caldeirão já tem ingredientes demais.", FeedbackType.WARNING)
		return
	
	if not cauldron.add_ingredient(ingredient_id):
		show_result("Não foi possível adicionar o ingrediente.", FeedbackType.WARNING)
		return
	
	var added_ingredient_name = get_ingredient_display_name(ingredient_id)
	show_result("%s adicionado ao caldeirão." % added_ingredient_name, FeedbackType.INFO)
	
	update_buttons()

func mix_potion() -> void:
	match cauldron.state:
		Cauldron.State.EMPTY:
			show_result("Adicione um ingrediente primeiro.", FeedbackType.WARNING)
			return
			
		Cauldron.State.POTION_READY:
			show_result("A poção já foi misturada.", FeedbackType.WARNING)
			return
	
	if not cauldron.mix():
		show_result("Não foi possível misturar a poção.", FeedbackType.WARNING)
		return
	
	show_result("A poção foi misturada.", FeedbackType.INFO)
	
	update_buttons()

func deliver_potion() -> void:
	if current_customer == null:
		push_warning("Nenhum cliente para essa entrega de poção.")
		return
	
	if current_customer.requested_recipe == null:
		push_warning("Nenhuma receita para o cliente atual.")
		return
	
	match cauldron.state:
		Cauldron.State.EMPTY:
			show_result("Não há poção para entregar.", FeedbackType.WARNING)
			return
	
		Cauldron.State.RECEIVING_INGREDIENTS:
			show_result("Misture a poção antes de entregar.", FeedbackType.WARNING)
			return
	
		Cauldron.State.POTION_READY:
			if is_correct_potion():
				var success_msg = "%s ficou feliz! +%d moedas!" % [
					current_customer.display_name,
					current_customer.reward
				]
				show_result(success_msg, FeedbackType.SUCCESS)
				add_money(current_customer.reward)
				complete_customer_service()
			else:
				var error_msg = "Poção errada! %s ficou irritado." % [
					current_customer.display_name
				]
				show_result(error_msg, FeedbackType.ERROR)
				lose_reputation()
				cauldron.clear()
			
			return
	
	update_buttons()

func clear_cauldron() -> void:
	cauldron.clear()
	show_result("Caldeirão limpo.", FeedbackType.INFO)
	update_buttons()

func restart_game() -> void:
	money = 0
	money_changed.emit(money)
	reputation = STARTING_REPUTATION
	reputation_changed.emit(reputation)
	
	is_game_over = false
	
	cauldron.clear()
	pick_next_customer()
	update_buttons()

func show_result(message: String, feedback_type: FeedbackType = FeedbackType.INFO) -> void:
	result_label.text = message
	update_result_panel(feedback_type)
	print(message)

func pick_next_customer(show_arrival_message := true) -> void:
	if available_customers.is_empty():
		current_customer = null
		customer_panel.set_customer(null)
		show_result("Nenhum cliente disponível.", FeedbackType.WARNING)
		update_buttons()
		return
	
	current_customer = available_customers.pick_random()
	
	if show_arrival_message:
		show_result("%s chegou à loja" % current_customer.display_name, FeedbackType.INFO)
	
	customer.setup(current_customer)
	
	update_customer_view()
	update_buttons()

func complete_customer_service() -> void:
	potion_button.visible = false
	served_customers_count += 1
	customer.clear()
	cauldron.clear()
	pick_next_customer(false)

func update_cauldron_label() -> void:
	var ingredient_ids := cauldron.get_ingredient_ids()
	
	if ingredient_ids.is_empty():
		cauldron_ingredients_label.text = "Caldeirão Vazio"
		return
	
	var ingredient_names: Array[String] = []
	
	for ingredient_id in ingredient_ids:
		ingredient_names.append(get_ingredient_display_name(ingredient_id))
	
	cauldron_ingredients_label.text = ", ".join(ingredient_names)

func update_result_panel(feedback_type: FeedbackType) -> void:
	var style_box := StyleBoxFlat.new()
	
	match feedback_type:
		FeedbackType.SUCCESS:
			style_box.bg_color = Color(0.18, 0.45, 0.25)
		FeedbackType.ERROR:
			style_box.bg_color = Color(0.55, 0.18, 0.18)
		FeedbackType.WARNING:
			style_box.bg_color = Color(0.55, 0.42, 0.16)
		FeedbackType.INFO:
			style_box.bg_color = Color(0.20, 0.20, 0.22)
	
	result_panel.add_theme_stylebox_override("panel", style_box)

func update_buttons() -> void:
	
	if is_game_over:
		herb_card.disabled = true
		lavender_card.disabled = true
		pepper_card.disabled = true
		mix_button.disabled = true
		deliver_button.disabled = true
		clear_button.disabled = true
		restart_button.disabled = false
		return
	
	var can_add := cauldron.can_add_ingredient()
	
	herb_card.disabled = not can_add
	lavender_card.disabled = not can_add
	pepper_card.disabled = not can_add
	
	mix_button.disabled = not cauldron.can_mix()
	deliver_button.disabled = not can_deliver_potion()
	clear_button.disabled = not cauldron.can_clear()
	
	restart_button.disabled = false

func update_customer_view() -> void:
	customer_panel.set_customer(current_customer)

func can_deliver_potion() -> bool:
	return cauldron.state == Cauldron.State.POTION_READY
	
func is_correct_potion() -> bool:
	var current_recipe := get_current_recipe()
	if current_recipe == null:
		push_warning("Nenhuma receita configurada.")
		return false
	
	var ingredient_ids := cauldron.get_ingredient_ids()
	
	for required_ingredient in current_recipe.required_ingredients:
		if not ingredient_ids.has(required_ingredient.id):
			return false
	
	return true

func get_ingredient_display_name(ingredient_id: String) -> String:
	if not ingredient_by_id.has(ingredient_id):
		push_warning("Ingrediente sem display_name encontrado: %s" % ingredient_id)
		return ingredient_id
	
	return ingredient_by_id[ingredient_id].display_name

func get_current_recipe() -> RecipeData:
	if current_customer == null:
		return null
	
	return current_customer.requested_recipe

func _on_customer_patience_depleted(customer_data: CustomerData) -> void:
	show_result("%s foi embora irritado." % customer_data.display_name, FeedbackType.ERROR)
	lose_reputation()
	
	if not is_game_over:
		pick_next_customer()

func build_ingredient_lookup() -> void:
	ingredient_by_id.clear()
	
	for ingredient in available_ingredients:
		if ingredient == null:
			continue
		
		if ingredient.id.is_empty():
			push_warning("Ingrediente sem id encontrado.")
			continue
		
		if ingredient_by_id.has(ingredient.id):
			push_warning("Ingrediente duplicado: %s" % ingredient.id)
			continue
		
		ingredient_by_id[ingredient.id] = ingredient

func add_money(amount: int) -> void:
	money += amount
	money_changed.emit(money)

func lose_reputation(amount: int = 1) -> void:
	reputation = max(reputation - amount, 0)
	reputation_changed.emit(reputation)
	
	if reputation == 0:
		is_game_over = true
		game_lost.emit("reputation")
		show_result("Você perdeu a reputação da loja.", FeedbackType.ERROR)
		update_buttons()

func update_hud() -> void:
	money_label.text = "Moedas: %d" % money
	reputation_label.text = "Reputação: %d/%d" % [reputation, MAX_REPUTATION]

func _on_money_changed(_new_value: int) -> void:
	update_hud()

func _on_reputation_changed(_new_value: int) -> void:
	update_hud()

func _on_cauldron_ingredients_changed(_ingredient_ids: Array[String]) -> void:
	update_cauldron_label()
	update_buttons()

func _on_cauldron_potion_mixed(_ingredient_ids: Array[String]) -> void:
	potion_button.visible = true
	update_buttons()

func _on_cauldron_cleared() -> void:
	potion_button.visible = false
	update_cauldron_label()
	update_buttons()

func _on_ingredient_selected(ingredient_data: IngredientData) -> void:
	try_add_ingredient(ingredient_data.id)

func _on_clear_button_pressed() -> void:
	clear_cauldron()

func _on_mix_button_pressed() -> void:
	mix_potion()

func _on_deliver_button_pressed() -> void:
	deliver_potion()

func _on_restart_button_pressed() -> void:
	restart_game()

func _on_cauldron_button_pressed() -> void:
	mix_potion()

func _on_potion_button_pressed() -> void:
	deliver_potion()
	potion_button.visible = false

func _on_potion_button_mouse_entered() -> void:
	pass

func _on_potion_button_mouse_exited() -> void:
	pass # Replace with function body.

func _on_cauldron_button_mouse_entered() -> void:
	cauldron_vision.position = Vector2(0, -8)
	cauldron_vision.scale = Vector2(1.2, 1.2)
	cauldron_vision.z_index = 100

func _on_cauldron_button_mouse_exited() -> void:
	cauldron_vision.position = Vector2.ZERO
	cauldron_vision.scale = Vector2.ONE
	cauldron_vision.z_index = 0
