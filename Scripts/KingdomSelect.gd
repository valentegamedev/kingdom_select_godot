extends Spatial

export (Array, Resource) var kingdoms
export (NodePath) onready var model = get_node(model) as Spatial
export (NodePath) onready var kingdom_buttons_container = get_node(kingdom_buttons_container) as Control
var kingdom_point_scene = preload("res://Prefabs/KingdomPoint.tscn")
var kingdom_button_scene = preload("res://Prefabs/KingdomButton.tscn")
export (float) var look_duration
export (Vector2) var visual_offset

export var start_index = 0

var currentSelectedButton = null

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		start_index+=1
		if start_index >= kingdoms.size():
			start_index = 0
		
		look_at_kingdom(kingdoms[start_index])
		
func _ready():
	for k in kingdoms:
		spawn_kingdom_point(k)
		
	if kingdoms.size() > 0:
		look_at_kingdom(kingdoms[start_index])
	
func spawn_kingdom_point(k:Kingdom):
	var kingdom = kingdom_point_scene.instance()
	model.add_child(kingdom)
	kingdom.rotation_degrees = Vector3(k.y + visual_offset.y, k.x + visual_offset.x, 0)
	k.visual_point = kingdom.get_child(0)
	
	spawn_kingdom_button(k)
	
func spawn_kingdom_button(k:Kingdom):
	var kingdom_button = kingdom_button_scene.instance()
	kingdom_button.kingdom = k
	kingdom_buttons_container.add_child(kingdom_button)
	kingdom_button.get_child(0).get_child(0).get_child(0).text = k.name
	
	kingdom_button.connect("world_selected", self, "_world_selected")

func gimbal_lock_fix(quat):
	var camera_pivot = get_tree().get_root().get_node("SampleScene/CameraPivot")
	camera_pivot.global_transform = Transform(quat, camera_pivot.global_transform.origin)

func look_at_kingdom(k:Kingdom):
	#var camera_parent = get_tree().get_root().get_node("SampleScene/CameraPivot/CameraParent")
	var camera_pivot = get_tree().get_root().get_node("SampleScene/CameraPivot")
	
	var spatial = Spatial.new()
	add_child(spatial)
	spatial.rotation_degrees = Vector3(k.y, k.x, 0)
	var kingdom_quat = Quat(spatial.global_transform.basis)
	spatial.queue_free()
	
	var s = TweenSequence.new(get_tree())
	s.append_method(self, "gimbal_lock_fix", Quat(camera_pivot.transform.basis), kingdom_quat, look_duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	#$Tween.interpolate_property(camera_pivot, "global_transform", camera_pivot.global_transform, Transform(kingdom_basis, camera_pivot.global_transform.origin), look_duration, Tween.TRANS_QUART, Tween.EASE_OUT)
	
	#$Tween.interpolate_property(camera_parent, "rotation_degrees", camera_parent.rotation_degrees, Vector3(k.y, 0, 0), look_duration, Tween.TRANS_QUART, Tween.EASE_OUT)
	#$Tween.interpolate_property(camera_pivot, "rotation_degrees", camera_pivot.rotation_degrees, Vector3(0, k.x, 0), look_duration, Tween.TRANS_QUART, Tween.EASE_OUT)
	#$Tween.start()
	
	get_tree().get_root().get_node("SampleScene/Canvas/Indicator").target = k.visual_point

func _world_selected(button):
	for b in kingdom_buttons_container.get_children():
		b.deselect()
	look_at_kingdom(button.kingdom)
	currentSelectedButton = button
