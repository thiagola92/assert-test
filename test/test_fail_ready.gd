extends Node


func _ready() -> void:
	get_tree().create_timer(1).timeout.connect(func(): get_tree().quit(1))
	
	assert(false, "_ready")
