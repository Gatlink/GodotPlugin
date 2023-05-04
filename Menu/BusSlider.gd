extends HBoxContainer


@export var label_text : String
@export var bus_name : String
@export var highlight_color : Color


@onready var label : Label = $Label
@onready var slider : HSlider = $HSlider
@onready var normal_color : Color = label.get_theme_color("font_color")
@onready var bus_id := AudioServer.get_bus_index(bus_name)


func _ready() -> void:
	label.text = label_text
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_id))


func _on_HSlider_focus_entered() -> void:
	label.add_theme_color_override("font_color", highlight_color)


func _on_HSlider_focus_exited() -> void:
	label.add_theme_color_override("font_color", normal_color)


func _on_HSlider_value_changed(value : float) -> void:
	AudioServer.set_bus_volume_db(bus_id, linear_to_db(value))
