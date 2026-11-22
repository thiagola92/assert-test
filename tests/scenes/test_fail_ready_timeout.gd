extends Node


func _ready() -> void:
	# Failing assert makes you leave the function, so quit() is never called.
	assert(false, "assert inside _ready() before quit()")
	
	get_tree().quit()
