extends CharacterBody2D

const JUMP_VELOCITY: int = -300
const PLAYER_SPEED: int = 100

@onready var animated_sprite = $AnimatedSprite2D
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: int = 1
var facing_direction: bool = false

enum PlayerState {IDLE, MOVING, JUMPING, RUNNING, FALLING, COLLIDING, SLIDING}
var state: PlayerState = PlayerState.IDLE: set = set_player_state

func set_player_state(new_state: PlayerState) -> void:
	var previous_state: PlayerState = state
	state = new_state
	
	if state == PlayerState.RUNNING:
		animated_sprite.play("run")
	
	if state == PlayerState.IDLE:
		animated_sprite.play("idle")

func _physics_process(delta):
	if velocity.y > 0 and not is_on_floor():
		set_player_state(PlayerState.FALLING)
	
	direction = Input.get_axis("left", "right")
	if direction == 1:
		facing_direction = false
	elif direction == -1:
		facing_direction = true

	if state != PlayerState.FALLING and direction != 0:
		set_player_state(PlayerState.MOVING)
	
	if (
		state == PlayerState.FALLING
		and (ray_cast_left.is_colliding() or ray_cast_right.is_colliding())
		and direction != 0
	):
		set_player_state(PlayerState.SLIDING)

	if not is_on_floor():
		if state == PlayerState.SLIDING:
			velocity.y += (gravity * delta) / 4
		else:
			velocity.y += gravity * delta
	
	if is_on_floor() and state != PlayerState.MOVING:
		set_player_state(PlayerState.IDLE)
	elif is_on_floor() and state == PlayerState.MOVING:
		set_player_state(PlayerState.RUNNING)

	if (
		Input.is_action_just_pressed("jump")
		# Basic jump or wall jump
		and (is_on_floor() or state == PlayerState.SLIDING)
	):
		velocity.y = JUMP_VELOCITY
		set_player_state(PlayerState.JUMPING)
	
	
	velocity.x = direction * PLAYER_SPEED

	animated_sprite.flip_h = facing_direction
	
	move_and_slide()

func die():
	animated_sprite.play("death")
