extends Control

@onready var title_label = $TitleLabel
@onready var subtitle_label = $SubtitleLabel

var fade_version: int = 0

func _ready() -> void:
	GameManager.day_started.connect(_on_day_started)
	_on_day_started(GameManager.day)


func _on_day_started(day: int) -> void:
	fade_version += 1
	var my_version := fade_version

	if day == 1:
		title_label.text = "Siberia, 1976"
		subtitle_label.text = "Day 1"
	else:
		title_label.text = ""
		subtitle_label.text = "Day %d" % day

	# reset visibility
	modulate.a = 1.0

	# wait before fade
	await get_tree().create_timer(4.0).timeout

	# if a new day started while we were waiting, abort
	if my_version != fade_version:
		return

	# fade out over 2 seconds
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 2.0)
	await tween.finished
