extends Control

enum FeedbackType {
	INFO,
	SUCCESS,
	WARNING,
	ERROR
}

@export var available_ingredients: Array[IngredientData] = []
@export var available_customers: Array[CustomerData] = []

@onready var cauldron: Cauldron = %Cauldron

@onready var customer_panel: CustomerView = %CustomerPanel

@onready var cauldron_ingredients_label: Label = %CauldronIngredientsLabel
@onready var result_label: Label = %ResultLabel
@onready var result_panel: PanelContainer = %ResultPanel

@onready var herb_button: IngredientButton = %HerbButton
@onready var lavender_button: IngredientButton = %LavenderButton
@onready var pepper_button: IngredientButton = %PepperButton

@onready var mix_button: Button = %MixButton
@onready var deliver_button: Button = %DeliverButton
@onready var clear_button: Button = %ClearButton
@onready var restart_button: Button = %RestartButton

var ingredient_by_id: Dictionary = {}
var current_customer: CustomerData
var served_customers_count: int = 0

func _ready() -> void:
	build_ingredient_lookup()
	
	cauldron.ingredients_changed.connect(_on_cauldron_ingredients_changed)
	cauldron.potion_mixed.connect(_on_cauldron_potion_mixed)
	cauldron.cauldron_cleared.connect(_on_cauldron_cleared)
	
	herb_button.ingredient_selected.connect(_on_ingredient_selected)
	lavender_button.ingredient_selected.connect(_on_ingredient_selected)
	pepper_button.ingredient_selected.connect(_on_ingredient_selected)
	
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
				complete_customer_service()
			else:
				var error_msg = "Poção errada! %s ficou irritado." % [
					current_customer.display_name
				]
				show_result(error_msg, FeedbackType.ERROR)
				cauldron.clear()
			
			return
	
	update_buttons()

func clear_cauldron() -> void:
	cauldron.clear()
	show_result("Caldeirão limpo.", FeedbackType.INFO)
	update_buttons()

func restart_game() -> void:
	cauldron.clear()
	show_result("Jogo Reiniciado", FeedbackType.INFO)
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
	
	update_customer_view()
	update_buttons()

func complete_customer_service() -> void:
	served_customers_count += 1
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
	var can_add := cauldron.can_add_ingredient()
	
	herb_button.disabled = not can_add
	lavender_button.disabled = not can_add
	pepper_button.disabled = not can_add
	
	mix_button.disabled = not cauldron.can_mix()
	deliver_button.disabled = not can_deliver_potion()
	clear_button.disabled = not cauldron.can_clear()
	
	restart_button.disabled = false

func update_customer_view() -> void:
	customer_panel.set_customer(current_customer)

func can_deliver_potion() -> bool:
	return cauldron.state == Cauldron.State.POTION_READY
	
func is_correct_potion() -> bool:
	var current_recipe = get_current_recipe()
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

func _on_cauldron_ingredients_changed(_ingredient_ids: Array[String]) -> void:
	update_cauldron_label()
	update_buttons()

func _on_cauldron_potion_mixed(_ingredient_ids: Array[String]) -> void:
	update_buttons()

func _on_cauldron_cleared() -> void:
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
