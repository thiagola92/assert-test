@icon("res://addons/assert_test/assert_suit.svg")
@tool
class_name AssertSuit
extends Node


signal scene_reporting(scene: AssertScene)

signal suit_reporting

## If [code]true[/code], hide all reports.
@export var show_report: bool = true

## If [code]true[/code], hide report that didn't failed.
@export var hide_ok: bool = false

var success_count: int = 0

var fail_count: int = 0

var tests_count: int = 0


func _ready() -> void:
	scene_reporting.connect(_on_scene_reporting)
	suit_reporting.connect(_on_suit_reporting)
	
	for c in get_children():
		if c is AssertScene and not Engine.is_editor_hint():
			c.finished.connect(_on_assert_scene_finished.bind(c))
			c.start()
			
			tests_count += 1


func _get_configuration_warnings() -> PackedStringArray:
	for c in get_children():
		if c is not AssertScene:
			return ["All nodes children should be AssertScene"]
	return []


func print_report() -> void:
	print_rich("%s %s, %s %s" % [
		success_count,
		AssertScene.OK_MESSAGE,
		fail_count,
		AssertScene.FAIL_MESSAGE
	])


func _on_assert_scene_finished(scene: AssertScene) -> void:
	if scene.is_ok():
		success_count += 1
	else:
		fail_count += 1
	
	scene_reporting.emit(scene)
	
	if (success_count + fail_count) == tests_count:
		suit_reporting.emit()


func _on_scene_reporting(scene: AssertScene) -> void:
	if show_report:
		if scene.is_ok() and hide_ok:
			return
		scene.print_report()


func _on_suit_reporting() -> void:
	if show_report:
		print_report()
