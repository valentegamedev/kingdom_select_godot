extends Control

var target:Spatial = null

func _ready():
	$AnimationPlayerCircleOne.play("IndicatorAnimation")
	yield(get_tree().create_timer(.5), "timeout")
	$AnimationPlayerCircleTwo.play("IndicatorAnimation")

func _process(delta):
	if target:
		var camera = get_tree().get_root().get_node("SampleScene/CameraPivot/CameraParent/Camera")
		rect_position = camera.unproject_position(target.global_transform.origin)
