extends Node


func _ready() -> void:
	get_tree().quit.call_deferred()
	
	@warning_ignore("assert_always_true")
	assert(true, "everything should work just fine")
	
	@warning_ignore("assert_always_true")
	assert(1+1==2, "everything should work just fine")
