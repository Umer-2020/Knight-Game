extends Area2D

@export var message:String = "Change msg"
@onready var label: Label = $Label

func _ready() -> void:
	label.visible = false

func _on_body_entered(body: Node2D) -> void:
	label.visible = true
	label.text = message


func _on_body_exited(body: Node2D) -> void:
	label.visible = false
