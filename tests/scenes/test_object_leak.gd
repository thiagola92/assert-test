extends Node


func _ready() -> void:
	@warning_ignore("unused_variable")
	var a := Object.new()
	
	get_tree().quit.call_deferred()
