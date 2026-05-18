extends CharacterBody2D

const SPEED := 130.0
const JUMP_VELOCITY := -300.0
const DASH_SPEED := 400.0
const DASH_TIME := 0.10

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum PlayerState {IDLE, RUN, JUMP, FALL, DASH}
var state: PlayerState = PlayerState.IDLE # Default State

var can_double_jump := true
var can_dash := true
var dash_timer := 0.0


func _physics_process(delta: float) -> void:
	update_state()
	apply_gravity(delta)
	update_ground_flags()
	handle_state(delta)
	update_animation()
	move_and_slide()



func update_state() -> void:
	# Dash overrides everything
	if state == PlayerState.DASH:
		return                # returns out of function with the Dash state

	if not is_on_floor():
		if velocity.y < 0:    # The player is moving upwards
			state = PlayerState.JUMP
		else:                 # The player is falling down
			state = PlayerState.FALL
	else:
		if velocity.x == 0:
			state = PlayerState.IDLE
		else:
			state = PlayerState.RUN



func handle_state(delta: float) -> void:
	match state:
		PlayerState.IDLE, PlayerState.RUN:
			handle_ground_movement()
			check_jump()
			check_dash()

		PlayerState.JUMP, PlayerState.FALL:
			handle_air_movement()
			check_jump()
			check_dash()

		PlayerState.DASH:
			handle_dash_state(delta)


# ─────────────────────────────────────────────
# Movement
# ─────────────────────────────────────────────
func apply_gravity(delta: float) -> void:
	if not is_on_floor() and state != PlayerState.DASH:
		velocity += get_gravity() * delta


func handle_ground_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	update_facing(direction)


func handle_air_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * SPEED
	update_facing(direction)


# ─────────────────────────────────────────────
# Jump Logic
# ─────────────────────────────────────────────
func check_jump() -> void:
	if not Input.is_action_just_pressed("jump"):
		return

	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		can_double_jump = true
	elif can_double_jump:
		velocity.y = JUMP_VELOCITY
		can_double_jump = false


# ─────────────────────────────────────────────
# Dash Logic
# ─────────────────────────────────────────────
func check_dash() -> void:
	if Input.is_action_just_pressed("dash") and can_dash:
		start_dash()


func start_dash() -> void:
	state = PlayerState.DASH
	can_dash = false
	dash_timer = DASH_TIME
	velocity.y = 0

	var direction := Input.get_axis("move_left", "move_right")
	if direction == 0:     # if the character is standing still then you assign the direction based on the direction of the sprite
		direction = -1 if sprite.flip_h else 1

	velocity.x = direction * DASH_SPEED


func handle_dash_state(delta: float) -> void:
	dash_timer -= delta
	if dash_timer <= 0:
		state = PlayerState.FALL


# ─────────────────────────────────────────────
# Ground Flags
# ─────────────────────────────────────────────
func update_ground_flags() -> void:
	if is_on_floor():
		can_double_jump = true
		can_dash = true


# ─────────────────────────────────────────────
# Animation & Facing
# ─────────────────────────────────────────────
func update_facing(direction: float) -> void:
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true


func update_animation() -> void:
	match state:
		PlayerState.IDLE:
			sprite.play("idle")
		PlayerState.RUN:
			sprite.play("run")
		PlayerState.JUMP, PlayerState.FALL:
			sprite.play("jump")
