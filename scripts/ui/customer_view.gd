class_name CustomerView
extends PanelContainer

@onready var customer_title_label: Label = %CustomerTitleLabel
@onready var order_label: Label = %OrderLabel
@onready var portrait_rect: TextureRect = %PortraitRect
@onready var patience_bar: ProgressBar = %PatienceBar

func set_customer(customer_data: CustomerData) -> void:
	if customer_data == null:
		customer_title_label.text = "Sem cliente."
		order_label.text = "Nenhum pedido."
		return
	
	portrait_rect.texture = customer_data.portrait
	customer_title_label.text = customer_data.display_name
	
	if customer_data.requested_recipe == null:
		order_label.text = "Não sabe o que pedir."
		return
	
	order_label.text = customer_data.requested_recipe.order_text

func set_patience_ratio(ratio: float) -> void:
	patience_bar.value = clampf(ratio, 0.0, 1.0) * 100.0
