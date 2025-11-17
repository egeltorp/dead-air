extends Node

var using_terminal: bool = false
var current_terminal: Node = null

var can_sleep: bool = false

func enter_terminal(terminal: Node):
	using_terminal = true
	current_terminal = terminal

func exit_terminal():
	using_terminal = false
	current_terminal = null
