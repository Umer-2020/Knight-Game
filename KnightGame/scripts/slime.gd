extends Node2D

const SPEED = 60
const FALL_SPEED = 120
var direction = 1
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _process(delta: float) -> void:
	
	if not ray_cast_down.is_colliding():
		position.y+= FALL_SPEED*delta
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	
	# 𝜟 is the amount of time passed since the prev frame. 𝜟 = 1/fps. So, if you have high fps then 𝜟 is small or vice versa
	# Moving the x-position by (SPEED x 𝜟) will thereby ensure that the enemy is moving at constant speed
	# direction will control where the slime is moving +1(right) & -1(left)
	position.x += direction*SPEED*delta
