extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	print("You Died!")
	Engine.time_scale = 0.5   # When you die it will become slo-mo for dramatic effect
	body.get_node("CollisionShape2D").queue_free()  # The "body" is the body that entered i.e: the Player. So it goes to the Collision of Player and removes it, making the player fall through the map when he dies
	timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0  # I need to change the slo-mo back to normal
	get_tree().reload_current_scene()   # You are accessing the scene tree and reloading it
