extends Node


func _ready() -> void:
	get_tree().quit()
	
	(func(): assert(false, "assertion inside lambda function")).call()
