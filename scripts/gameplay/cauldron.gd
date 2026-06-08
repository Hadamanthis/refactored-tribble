class_name Cauldron
extends Node

signal ingredients_changed(ingredient_ids: Array[String])
signal potion_mixed(ingredient_ids: Array[String])
signal cauldron_cleared

enum State {
	EMPTY,
	RECEIVING_INGREDIENTS,
	POTION_READY
}

@export var ingredients_limit: int = 2

var state: State = State.EMPTY
var ingredient_ids: Array[String] = []

func add_ingredient(ingredient_id: String) -> bool:
	if not can_add_ingredient():
		return false
	
	ingredient_ids.append(ingredient_id)
	state = State.RECEIVING_INGREDIENTS
	ingredients_changed.emit(ingredient_ids.duplicate())
	
	return true

func mix() -> bool:
	if not can_mix():
		return false
	
	state = State.POTION_READY
	potion_mixed.emit(ingredient_ids.duplicate())
	
	return true

func clear() -> void:
	ingredient_ids.clear()
	state = State.EMPTY
	
	ingredients_changed.emit(ingredient_ids.duplicate())
	cauldron_cleared.emit()

func get_ingredient_ids() -> Array[String]:
	return ingredient_ids.duplicate()

func can_add_ingredient() -> bool:
	return (state == State.EMPTY
		or state == State.RECEIVING_INGREDIENTS) \
		and not is_full()

func can_mix() -> bool:
	return state == State.RECEIVING_INGREDIENTS \
		and not ingredient_ids.is_empty()

func can_clear() -> bool:
	return not ingredient_ids.is_empty()

func is_full() -> bool:
	return ingredient_ids.size() >= ingredients_limit
