extends Node


# When a function breaks in Godot, it returns the default value for that function.
# This test validates that we can predict a break.
func _ready() -> void:
	assert(bool_function() == false, "Didn't returned the default value of false")
	assert(int_function() == 0, "Didn't returned the default value of 0")
	assert(float_function() == 0.0, "Didn't returned the default value of 0.0")
	assert(string_function() == "", "Didn't returned the default value of empty string")
	
	get_tree().quit()


func bool_function() -> bool:
	assert(false, "Forced fail")
	
	return true


func int_function() -> int:
	assert(false, "Forced fail")
	
	return 1


func float_function() -> float:
	assert(false, "Forced fail")
	
	return 1.0


func string_function() -> String:
	assert(false, "Forced fail")
	
	return "a"
