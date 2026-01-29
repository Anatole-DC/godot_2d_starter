extends CharacterBody2D

const JUMP_VELOCITY: int = -300
const PLAYER_SPEED: int = 100
@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	direction = Input.get_axis("left", "right")
	velocity.x = direction * PLAYER_SPEED
	if velocity.x != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	animated_sprite.flip_h = (direction < 0)
	
	move_and_slide()

func die():
	animated_sprite.play("death")
