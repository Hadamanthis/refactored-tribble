class_name Customer
extends Node

signal patience_changed(ratio: float)
signal patience_depleted(customer_data: CustomerData)

var data: CustomerData
var current_patience: float = 0.0
var max_patience: float = 1.0
var is_active := false

func setup(customer_data: CustomerData) -> void:
	data = customer_data
	max_patience = data.base_patience
	current_patience = max_patience
	is_active = true
	patience_changed.emit(1.0)

func _process(delta: float) -> void:
	if not is_active:
		return
	
	current_patience -= delta
	patience_changed.emit(current_patience / max_patience)
	
	if current_patience <= 0:
		is_active = false
		patience_depleted.emit(data)

func clear() -> void:
	data = null
	is_active = false
	current_patience = 0.0
	patience_changed.emit(0.0)
