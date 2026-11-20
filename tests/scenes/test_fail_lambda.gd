extends Node


func _ready() -> void:
	get_tree().quit.call_deferred()
	
	(func(): assert(false, "assertion inside lambda function")).call()
