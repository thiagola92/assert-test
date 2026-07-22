extends Node


func _ready() -> void:
	get_tree().quit.call_deferred(1)
	
	(func(): assert(false, "assertion inside lambda function")).call()
