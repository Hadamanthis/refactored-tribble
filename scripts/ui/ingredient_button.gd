class_name IngredientButton
extends Button

signal ingredient_selected(ingredient_data: IngredientData)

@export var ingredient_data: IngredientData

func _ready() -> void:
	if ingredient_data == null:
		text = "Ingrediente"
		return
	
	text = ingredient_data.display_name

func _on_pressed() -> void:
	if ingredient_data == null:
		return
	
	ingredient_selected.emit(ingredient_data)
