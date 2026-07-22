extends Node


func _ready() -> void:
	get_tree().quit.call_deferred(1)
	
	function_call()


func function_call():
	assert(false, "assertion inside function")
