extends Control

var kingdom
export (NodePath) onready var label = get_node(label) as Label
export (Color) var rect_color_mouser_over
export (Color) var text_color_when_selected

signal world_selected(button)

func _ready():
	$Rect/NinePatchRect/Label.set("custom_colors/font_color", Color.white)
	$Rect/NinePatchRect.self_modulate = Color.transparent
	$Rect/Circle.material.set_shader_param("color", Color.white)

func deselect():
	$Rect/NinePatchRect/Label.set("custom_colors/font_color", Color.white)
	$Rect/NinePatchRect.self_modulate = Color.transparent
	$Rect/Circle.material.set_shader_param("color", Color.white)

func _on_Rect_button_down():
	emit_signal("world_selected", self)
	$Rect/NinePatchRect/Label.set("custom_colors/font_color", text_color_when_selected)
	$Rect/NinePatchRect.self_modulate = Color.white
	$Rect/Circle.material.set_shader_param("color", Color.red)	
	print("_on_Rect_button_down")

func _on_Rect_mouse_entered():
	if  get_tree().get_root().get_node("SampleScene/KingdomSelect").currentSelectedButton != self:
		var s = TweenSequence.new(get_tree())
		s.append($Rect/NinePatchRect, "self_modulate", rect_color_mouser_over, .2)


func _on_Rect_mouse_exited():
	if  get_tree().get_root().get_node("SampleScene/KingdomSelect").currentSelectedButton != self:
		var s = TweenSequence.new(get_tree())
		s.append($Rect/NinePatchRect, "self_modulate", Color.transparent, .2)
