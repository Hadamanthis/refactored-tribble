class_name IngredientCard
extends Button

signal ingredient_selected(ingredient_data: IngredientData)

@export var ingredient_data: IngredientData

@onready var icon_slot: CenterContainer = %IconSlot
@onready var icon_rect: TextureRect = %IconRect
@onready var name_label: Label = %NameLabel
@onready var visual_root: Control = %VisualRoot
@onready var hover_border: Panel = %HoverBorder

var rest_position := Vector2.ZERO
var rest_rotation := 0.0
var rest_z_index := 0

func _ready() -> void:
	resized.connect(update_visual_layout)
	call_deferred("update_visual_layout")
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	if ingredient_data == null:
		name_label.text = "Ingrediente"
		icon_rect.texture = null
		return
	
	text = ""
	name_label.text = ingredient_data.display_name
	icon_rect.texture = ingredient_data.icon

func update_visual_layout() -> void:
	var card_width := size.x
	var card_height := size.y
	
	visual_root.size = size
	visual_root.pivot_offset = size / 2.0
	
	name_label.position = Vector2(card_width * 0.12, card_height * 0.03)
	name_label.size = Vector2(card_width * 0.76, card_height * 0.12)
	name_label.add_theme_font_size_override("font_size", int(card_height * 0.075))
	
	var icon_slot_size := Vector2(card_width * 0.74, card_height * 0.52)
	icon_slot.position = Vector2(
		(card_width - icon_slot_size.x) / 2.0,
		card_height * 0.22
	)
	icon_slot.size = icon_slot_size
	
	var icon_size := minf(icon_slot_size.x, icon_slot_size.y) * 0.95
	icon_rect.custom_minimum_size = Vector2(icon_size, icon_size)
	
	hover_border.position = Vector2.ZERO
	hover_border.size = size

func set_rest_transform(new_position: Vector2, new_rotation: float, new_z_index: int) -> void:
	rest_position = new_position
	rest_rotation = new_rotation
	rest_z_index = new_z_index
	
	position = rest_position
	rotation_degrees = rest_rotation
	z_index = rest_z_index

func _on_pressed() -> void:
	if ingredient_data == null:
		return
	
	ingredient_selected.emit(ingredient_data)

func _on_mouse_entered() -> void:
	visual_root.position = Vector2(0.0, -35.0)
	hover_border.visible = true
	visual_root.scale = Vector2(1.5, 1.5)
	rotation_degrees = 0.0
	z_index = 100

func _on_mouse_exited() -> void:
	visual_root.position = Vector2.ZERO
	hover_border.visible = false
	visual_root.scale = Vector2.ONE
	rotation_degrees = rest_rotation
	z_index = rest_z_index
