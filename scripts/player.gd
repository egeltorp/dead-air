extends CharacterBody3D

@export var speed := 3.0
@export var mouse_sense := 0.003
@export var jump_power := 4.0
var gravity := -9.8 * 2
var velocity_y := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sense)
		$Camera3D.rotate_x(-event.relative.y * mouse_sense)
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -70, 89)

func _physics_process(delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = dir.x * speed
	velocity.z = dir.z * speed

	velocity_y += gravity * delta
	velocity.y = velocity_y
	
	move_and_slide()
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity_y = jump_power

	
