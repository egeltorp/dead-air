extends Node

var using_terminal: bool = false
var current_terminal: Node = null

var can_sleep: bool = false

var signal_playing: bool = false

var start_transform: Transform3D
var start_camera_transform: Transform3D

func enter_terminal(terminal: Node):
	using_terminal = true
	current_terminal = terminal

func exit_terminal():
	using_terminal = false
	current_terminal = null
