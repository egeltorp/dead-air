extends CharacterBody3D

@export var speed := 1.5
@export var mouse_sense := 0.003
@export var jump_power := 2.25
var gravity := -9.8 * 1.25
var velocity_y := 0.0

var spawn_pos: Vector3

@onready var terminal = null

@onready var player_camera := $Camera3D
@onready var ray := $Camera3D/InteractionRay
@onready var interact_cursor = $InteractCursor
@onready var regular_cursor = $RegularCursor
@onready var interact_label = $InteractionText
@onready var click = $Click

var current_interactable: Interactable = null

var exit_inputs = ["interact"]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	interact_cursor.visible = false
	interact_label.visible = false
	GameState.start_transform = global_transform
	GameState.start_camera_transform = player_camera.global_transform
	
	spawn_pos = global_position


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
		interact_label.visible = false
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
		if GameState.using_terminal:
			hide_interact()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power
		
	if Input.is_action_just_pressed("reset"):
		global_position = spawn_pos

	if Input.is_action_just_pressed("ui_cancel") and !GameState.using_terminal:
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			$"../Debug".visible = false
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			$"../Debug".visible = true

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var strafe_direction = transform.basis.x * input_dir.x
	var forward_direction = player_camera.global_transform.basis.z * input_dir.y  # Change direction to match correct forward movement

	velocity.x = (strafe_direction.x + forward_direction.x) * speed
	velocity.z = (strafe_direction.z + forward_direction.z) * speed

	move_and_slide()
	
	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj is Interactable:
			current_interactable = obj
			interact_label.text = obj.get_interact_text()
			interact_label.visible = true
			show_interact()
		else:
			clear_interactable()
	else:
		clear_interactable()

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
	if Input.is_action_just_pressed("interact"):
		click.play()
	
func hide_interact():
	regular_cursor.visible = true
	interact_cursor.visible = false
	
func clear_interactable():
	current_interactable = null
	interact_label.visible = false
	hide_interact()
	
func sleep():
	set_physics_process(false)
