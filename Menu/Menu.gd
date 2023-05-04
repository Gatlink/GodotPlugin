extends Control


const SUBMENU_ANIM_DURATION := 0.5
const SUBMENU_MARGIN_RIGHT := 50.0
const FOCUS_ACTIONS := [
	"ui_down",
	"ui_up",
	"ui_focus_next",
	"ui_focus_prev"
]
const SUB_MENUS := [
	"Settings"
]


@export var play_scene : PackedScene


@onready var container : VBoxContainer = $MainMenu
@onready var submenu_container : VBoxContainer = $SubMenu
@onready var mask : ColorRect = $MainMenuMask
@onready var window_width : float = get_window().size.x


var first_button : Button
var current_submenu : String
var last_submenu_button : Button
var tween : Tween
var mask_visible_color : Color
var mask_invisible_color : Color


func _ready() -> void:
	var last : Button
	for child in container.get_children():
		var button := child as Button
		if button != null:
			if first_button == null:
				first_button = button
			else:
				link_controls(last, button)
			
			last = button
	
	if first_button != null:
		link_controls(last, first_button)
	
	submenu_container.position.x = window_width
	mask_invisible_color = mask.color
	mask_visible_color = mask_invisible_color
	mask_visible_color.a = 0.98


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not current_submenu.is_empty():
			close_submenu()
	else:
		for action in FOCUS_ACTIONS:
			if event.is_action(action) and get_viewport().gui_get_viewport().gui_get_focus_owner() == null:
				first_button.grab_focus()


func link_controls(prev : Control, next : Control) -> void:
	var prev_path := prev.get_path()
	var next_path := next.get_path()
	prev.focus_neighbor_bottom = next_path
	prev.focus_next = next_path
	next.focus_neighbor_top = prev_path
	next.focus_previous = prev_path


func initialize_submenu(submenu : String) -> void:
	var controls := []
	for node in get_tree().get_nodes_in_group(submenu):
		node.visible = true
		add_focusable_node(node, controls)
	
	if controls.size() == 0:
		return
	
	var first : Control
	var prev : Control
	for node in controls:
		var control = node as Control
		if control != null:
			if prev != null:
				link_controls(prev, control)
			else:
				first = control
			
			prev = control
	
	link_controls(prev, first)
	
	first.grab_focus()


func add_focusable_node(node : Node, controls : Array) -> void:
	var control := node as Control
	if control != null and control.focus_mode != FOCUS_NONE:
		controls.append(control)
	
	for child in node.get_children():
		add_focusable_node(child, controls)


func submenu_anim(target_x : float) -> void:
	if tween != null:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(submenu_container, "position", Vector2(target_x, 0), SUBMENU_ANIM_DURATION)


func open_submenu(submenu : String) -> void:
	for other_menu in SUB_MENUS:
		for node in get_tree().get_nodes_in_group(other_menu):
			node.visible = false
	
	initialize_submenu(submenu)
	
	current_submenu = submenu
	
	mask.color = mask_invisible_color
	mask.visible = true
	submenu_anim(window_width - submenu_container.size.x - SUBMENU_MARGIN_RIGHT)
	tween.parallel().tween_property(mask, "color", mask_visible_color, SUBMENU_ANIM_DURATION).set_ease(Tween.EASE_OUT)


func close_submenu() -> void:
	if current_submenu.is_empty():
		return
	
	current_submenu = ""
	last_submenu_button.grab_focus()
	
	mask.color = mask_visible_color
	submenu_anim(window_width)
	tween.parallel().tween_property(mask, "color", mask_invisible_color, SUBMENU_ANIM_DURATION).set_ease(Tween.EASE_IN)
	tween.tween_callback(hide_current_submenu)
	tween.tween_property(mask, "visible", false, 0.0)


func hide_current_submenu() -> void:
	for node in get_tree().get_nodes_in_group(current_submenu):
		node.visible = false


func get_first_focusable_control(node : Node) -> Control:
	var control = node as Control
	if control != null and control.focus_mode != FOCUS_NONE:
		return control
	
	for child in node.get_children():
		control = get_first_focusable_control(child)
		
		if control != null:
			return control
	
	return null


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene_to_packed(play_scene)


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_submenu_button_pressed(submenu : String) -> void:
	last_submenu_button = get_viewport().gui_get_focus_owner()
	open_submenu(submenu)
