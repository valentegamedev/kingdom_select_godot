extends Node

onready var line = $LineRenderer
var points = [Vector3.ZERO, Vector3.ZERO, Vector3.ZERO];
var num_points = 50

var positions = [];

export (float) var distance
export (float, 0, 1) var distance_amount

func _ready():
	yield(get_tree().create_timer(.1), "timeout")
	positions.resize(num_points)
	
	var next_point
	if get_index()+1 < get_parent().get_child_count():
		next_point = get_parent().get_child(get_index()+1)
		set_mid_point(next_point)
		draw_quadratic_curve()

func set_mid_point(next_point):
	distance = get_child(0).global_transform.origin.distance_to(next_point.get_child(0).global_transform.origin)
	
	var point_normalized = lerp($Point.global_transform.origin, get_parent().get_child(get_index()+1).get_child(0).global_transform.origin, .5).normalized()
	var point = point_normalized/2 + point_normalized * distance * distance_amount
	
	points[0] = get_child(0).global_transform.origin
	points[1] = point
	points[2] = next_point.get_child(0).global_transform.origin

func draw_quadratic_curve():
	for i in num_points:
		var t = i/float(num_points)
		positions[i] = calculate_quadratic_bezier_point(t, points[0], points[1], points[2]);
	
	line.points = positions

func calculate_quadratic_bezier_point(t, p0, p1, p2):
	var u = 1 - t;
	var tt = t * t;
	var uu = u * u;
	var p = uu * p0;
	p += 2 * u * t * p1;
	p += tt * p2;
	return p;
