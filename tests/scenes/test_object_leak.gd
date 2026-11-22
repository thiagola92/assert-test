extends Node


func _ready() -> void:
	get_tree().quit()
	
	@warning_ignore("unused_variable")
	var a := Object.new()
