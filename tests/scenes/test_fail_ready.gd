extends Node


func _ready() -> void:
	get_tree().quit()
	
	assert(false, "assert inside _ready()")
