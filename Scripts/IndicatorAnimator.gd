extends TextureRect

var origSize

export (float) var duration
export (float) var delay

func _ready():
	modulate = Color(1, 1, 1, 0)
	origSize = rect_scale
	rect_scale = origSize / 4
	
	delay()

func delay():
	yield(get_tree().create_timer(delay), "timeout")
	animate()

	
func animate():
	var s = TweenSequence.new(get_tree())
	s.append(self, "rect_scale", origSize, duration).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	s.join().append(self, "modulate", Color(1, 1, 1, 1), duration / 3.0)
	s.join().append(self, "modulate", Color(1, 1, 1, 0), duration / 4.0).set_delay(duration / 1.5).from(Color(1, 1, 1, 1))
	s.append(self, "rect_scale", origSize / 4, 0)
	s.set_loops(-1)
	
