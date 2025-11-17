extends CharacterBody3D

@export var speed := 3.0
@export var mouse_sense := 0.003
@export var jump_power := 4.0
var gravity := -9.8 * 2
var velocity_y := 0.0

@onready var terminal = null

@onready var player_camera := $Camera3D
@onready var ray := $Camera3D/InteractionRay
@onready var interact_cursor = $InteractCursor
@onready var regular_cursor = $RegularCursor

var current_interactable: Interactable = null

var exit_inputs = ["interact"]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	interact_cursor.visible = false


func _input(event):
	if GameState.using_terminal:
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sense)
		player_camera.rotate_x(-event.relative.y * mouse_sense)
		player_camera.rotation_degrees.x = clamp(player_camera.rotation_degrees.x, -70, 89)
	if event.is_action_pressed("interact") and current_interactable:
		current_interactable.interact(self)


func _process(delta: float) -> void:
	if GameState.using_terminal:
		WaveformManager.update_player_tuning(delta)
		regular_cursor.visible = false
		if Input.is_action_just_pressed("switch_mode"):
			WaveformManager.switch_mode()
		if Input.is_action_just_pressed("escape"):
			exit_terminal()
		for input in exit_inputs:
			if Input.is_action_just_pressed(input):
				exit_terminal()
		return
	
	ray.force_raycast_update()
	var hit = ray.get_collider()
	
	if hit and hit.is_in_group("terminal"):
		show_interact()
		terminal = hit
		if Input.is_action_just_pressed("interact"):
			enter_terminal(hit)
	else:
		if terminal:
			hide_interact()

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = dir.x * speed
	velocity.z = dir.z * speed

	velocity_y += gravity * delta
	velocity.y = velocity_y
	
	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj is Interactable:
			current_interactable = obj
			show_interact()
		else:
			clear_interactable()
	else:
		clear_interactable()
	
	move_and_slide()
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity_y = jump_power

func enter_terminal(hit):
	GameState.using_terminal = true
	player_camera.current = false
	terminal.terminal_camera.current = true
	set_physics_process(false)
	hide_interact()

func exit_terminal():
	GameState.using_terminal = false
	player_camera.current = true
	terminal.terminal_camera.current = false
	set_physics_process(true)
	terminal = null
	
func show_interact():
	regular_cursor.visible = false
	interact_cursor.visible = true
	
func hide_interact():
	regular_cursor.visible = true
	interact_cursor.visible = false
	
func clear_interactable():
	current_interactable = null
	hide_interact()
