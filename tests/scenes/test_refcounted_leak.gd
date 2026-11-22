extends Node


func _ready() -> void:
	get_tree().quit()
	
	var e := Example.new()
	e.r = e


class Example extends RefCounted:
	var r: RefCounted = null
