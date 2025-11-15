extends Node2D

@export var freq := 5.0
@export var amp := 30.0
@export var phase := 0.0

@onready var waveform_box = $"../Incoming/WaveformBox"

func _process(delta):
	phase += delta * freq * 2.0 * PI
	queue_redraw()

func _draw():
	var rect = waveform_box.get_rect()
	var width = waveform_box.size.x
	var height = waveform_box.size.y
	var mid = height * 0.5
	
	draw_set_transform(waveform_box.position)

	var last = Vector2(0, mid)
	for x in range(width):
		var y = mid + sin((x / width) * freq * 2.0 * PI + phase) * amp
		var p = Vector2(x, y)
		draw_line(last, p, Color.WHITE, 2.0)
		last = p
