extends Node2D

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

const SLIME_SPEED: int = 60
var direction: int = 1

# Called every frame. 'delta' is the elapsed time since the previous frame
func handle_obstacles() -> int:
	if ray_cast_right.is_colliding():
		animated_sprite.flip_h = true
		return -1
	if ray_cast_left.is_colliding():
		animated_sprite.flip_h = false
		return 1
	return direction

func _process(delta):
	direction = handle_obstacles()
	position.x += SLIME_SPEED * delta * direction
