extends StaticBody2D

@onready var sprite = $Sprite2D

@export var powerup_scene: PackedScene
var can_be_hit = true

func _ready():
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0, 32, 16, 16) #x=0, y=32, w=16, h=16


func hit_from_below():
	if not can_be_hit:
		return
	can_be_hit = false
	sprite.region_rect = Rect2(0, 16, 16, 16) #x=0, y=16, w=16, h=16
	
	print("You hit the Mystery Box from below")
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 5, 0.1)
	tween.tween_property(self, "position:y", position.y, 0.1)
	
	if powerup_scene:
		call_deferred("_spawn_powerup")


func _on_hit_detection_area_body_entered(body:Node2D) -> void:
	if body is CharacterBody2D:
		hit_from_below()


func _spawn_powerup():
	var p = powerup_scene.instantiate()
	p.global_position = global_position + Vector2(0, -16)
	get_parent().add_child(p)
