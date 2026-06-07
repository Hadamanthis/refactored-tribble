class_name RecipeData
extends Resource

@export var id: String
@export var display_name: String
@export_multiline var order_text: String
@export var required_ingredients: Array[IngredientData] = []
@export var effect: String
@export var base_value: int = 5
