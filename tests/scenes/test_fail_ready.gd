extends Node


func _ready() -> void:
	get_tree().quit.call_deferred()
	
	assert(false, "assert inside _ready()")
