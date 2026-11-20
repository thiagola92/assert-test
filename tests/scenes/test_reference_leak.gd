extends Node


func _ready() -> void:
	var e := Example.new()
	e.r = e
	
	get_tree().quit.call_deferred()


class Example extends RefCounted:
	var r: RefCounted = null
