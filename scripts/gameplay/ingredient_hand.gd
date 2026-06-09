extends Control

@export var card_size := Vector2(180.0, 255.0)
@export var card_spacing := 115.0
@export var rotation_step := 8.0
@export var curve_depth := 28.0

func _ready() -> void:
	call_deferred("update_card_layout")

func update_card_layout() -> void:
	var cards := get_children()
	var card_count := cards.size()
	
	if card_count == 0:
		return
	
	var center := size / 2.0
	var center_index := (card_count - 1) / 2.0
	
	for index in card_count:
		var card := cards[index] as Control
		if card == null:
			continue
		
		var offset := index - center_index
		
		card.size = card_size
		card.pivot_offset = Vector2(card_size.x / 2.0, card_size.y)
		card.rotation_degrees = offset * rotation_step
		var target_position = Vector2(
			center.x - card_size.x / 2.0 + offset * card_spacing,
			center.y - card_size.y / 2.0 + abs(offset) * curve_depth
		)
		
		var target_rotation := offset * rotation_step
		var target_z_index := index
		
		card.pivot_offset = Vector2(card_size.x / 2.0, card_size.y)
	
		if card.has_method("set_rest_transform"):
			card.set_rest_transform(target_position, target_rotation, target_z_index)
		else:
			card.position = target_position
			card.rotation_degrees = target_rotation
			card.z_index = target_z_index

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		update_card_layout()
