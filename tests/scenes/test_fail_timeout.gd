extends Node


func _ready() -> void:
	@warning_ignore("assert_always_true")
	assert(true, "assert in a scene that never ends")
