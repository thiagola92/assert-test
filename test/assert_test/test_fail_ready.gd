extends Node


func _ready() -> void:
	get_tree().quit.call_deferred(1)
	
	assert(false, "assert inside _ready()")
