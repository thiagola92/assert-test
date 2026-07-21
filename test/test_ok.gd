extends Node


func _ready() -> void:
	get_tree().create_timer(1).timeout.connect(func(): get_tree().quit(1))
	
	@warning_ignore("assert_always_true")
	assert(true, "Everything should work just fine")
	
	@warning_ignore("assert_always_true")
	assert(1+1==2, "Everything should work just fine")
