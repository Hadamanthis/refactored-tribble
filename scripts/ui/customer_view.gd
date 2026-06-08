class_name CustomerView
extends PanelContainer

@onready var customer_title_label: Label = %CustomerTitleLabel
@onready var order_label: Label = %OrderLabel

func set_customer(customer_data: CustomerData) -> void:
	if customer_data == null:
		customer_title_label.text = "Sem cliente."
		order_label.text = "Nenhum pedido."
		return
	
	customer_title_label.text = customer_data.display_name
	
	if customer_data.requested_recipe == null:
		order_label.text = "Não sabe o que pedir."
		return
	
	order_label.text = customer_data.requested_recipe.order_text
