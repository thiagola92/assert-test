extends Node


func _ready() -> void:
	get_tree().quit()
	
	function_call()


func function_call():
	assert(false, "assertion inside function")
