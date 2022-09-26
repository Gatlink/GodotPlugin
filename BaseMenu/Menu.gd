extends Control


const FOCUS_ACTIONS := [
	"ui_down",
	"ui_up",
	"ui_focus_next",
	"ui_focus_prev"
]
const SUB_MENUS := [
	"Settings"
]


export (PackedScene) var play_scene : PackedScene


onready var container : VBoxContainer = $MainMenu
onready var animation : AnimationPlayer = $AnimationPlayer


var first_button : Button
var current_submenu : String
var last_submenu_button : Button


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
	
	for submenu in SUB_MENUS:
		initialize_submenu(submenu)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not current_submenu.empty():
			close_submenu()
	else:
		for action in FOCUS_ACTIONS:
			if event.is_action(action) and get_focus_owner() == null:
				first_button.grab_focus()


func link_controls(prev : Control, next : Control) -> void:
	var prev_path := prev.get_path()
	var next_path := next.get_path()
	prev.focus_neighbour_bottom = next_path
	prev.focus_next = next_path
	next.focus_neighbour_top = prev_path
	next.focus_previous = prev_path


func initialize_submenu(submenu : String) -> void:
	var controls := []
	for node in get_tree().get_nodes_in_group(submenu):
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


func add_focusable_node(node : Node, controls : Array) -> void:
	var control := node as Control
	if control != null and control.focus_mode != FOCUS_NONE:
		controls.append(control)
	
	for child in node.get_children():
		add_focusable_node(child, controls)


func open_submenu(submenu : String) -> void:
	var focused := false
	for other_menu in SUB_MENUS:
		for node in get_tree().get_nodes_in_group(other_menu):
			node.visible = other_menu == submenu
			
			if not focused and node.visible:
				var control := get_first_focusable_control(node)
				if control != null:
					focused = true
					control.grab_focus()
	
	animation.play("ShowSubMenu")
	current_submenu = submenu


func close_submenu() -> void:
	if current_submenu.empty():
		return
	
	animation.play("HideSubMenu")
	current_submenu = ""
	last_submenu_button.grab_focus()
	
	yield(animation, "animation_finished")
	
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
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(play_scene)


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_submenu_button_pressed(submenu : String) -> void:
	last_submenu_button = get_focus_owner()
	open_submenu(submenu)
