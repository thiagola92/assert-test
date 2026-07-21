extends Node


func _ready() -> void:
	get_tree().create_timer(1).timeout.connect(func(): get_tree().quit(1))
	
	function_call()


func function_call():
	assert(false, "function_call")
