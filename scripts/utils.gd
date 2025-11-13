extends Node

@onready var fps_label: Label

func _ready() -> void:
	fps_label = get_tree().get_current_scene().get_node("Debug/FPS")

func _process(_delta: float) -> void:
	fps_label.text = "FPS: %d" % Engine.get_frames_per_second()
