extends Spatial

export (Array, Resource) var kingdoms
export (NodePath) onready var model = get_node(model) as Spatial
var kingdom_point_scene = preload("res://Prefabs/KingdomPoint.tscn")

export (float) var look_duration
export (Vector2) var visual_offset

export var start_index = 0

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

func look_at_kingdom(k:Kingdom):
	var camera_parent = get_tree().get_root().get_node("SampleScene/CameraPivot/CameraParent")
	var camera_pivot = get_tree().get_root().get_node("SampleScene/CameraPivot")
	
	$Tween.interpolate_property(camera_parent, "rotation_degrees", camera_parent.rotation_degrees, Vector3(k.y, 0, 0), look_duration, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.interpolate_property(camera_pivot, "rotation_degrees", camera_pivot.rotation_degrees, Vector3(0, k.x, 0), look_duration, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.start()
	
	get_tree().get_root().get_node("SampleScene/Canvas/Indicator").target = k.visual_point
