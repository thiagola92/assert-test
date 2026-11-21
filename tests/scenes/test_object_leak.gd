extends Node


func _ready() -> void:
	var a := Object.new()
	var b := Object.new()
	
	a.free()
	b.free()
	
	get_tree().quit.call_deferred()
