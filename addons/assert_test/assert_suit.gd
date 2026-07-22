@icon("res://addons/assert_test/assert_suit.svg")
@tool
class_name AssertSuit
extends Node


enum ReportStyle {
	OK_FIRST,
	ONLY_FAIL,
	TEST_ORDER,
}

@export var report_style: ReportStyle = ReportStyle.OK_FIRST

var success_count: int = 0

var fail_count: int = 0

var tests_count: int = 0


func _init() -> void:
	child_entered_tree.connect(_on_child_entered_tree)


func _ready() -> void:
	for c in get_children():
		if c is AssertScene and not Engine.is_editor_hint():
			c.finished.connect(_on_assert_scene_finished)
			c.start()
			
			tests_count += 1


func _get_configuration_warnings() -> PackedStringArray:
	for c in get_children():
		if c is not AssertScene:
			return ["All nodes children should be AssertScene"]
	return []


func _on_child_entered_tree(node: Node) -> void:
	if node is AssertScene:
		node.autostart = false
		node.autoprint = false


func _on_assert_scene_finished(ok: bool) -> void:
	if ok:
		success_count += 1
	else:
		fail_count += 1
	
	if (success_count + fail_count) == tests_count:
		_print_report()


func _print_report() -> void:
	if report_style == ReportStyle.OK_FIRST:
		for c in get_children():
			if c is AssertScene:
				if c.is_ok():
					c.print_report()
		
		for c in get_children():
			if c is AssertScene:
				if not c.is_ok():
					c.print_report()
	elif report_style == ReportStyle.ONLY_FAIL:
		for c in get_children():
			if c is AssertScene:
				if not c.is_ok():
					c.print_report()
	elif report_style == ReportStyle.TEST_ORDER:
		for c in get_children():
			if c is AssertScene:
				c.print_report()
	
	print_rich("%s %s, %s %s" % [
		success_count,
		AssertScene.OK_MESSAGE,
		fail_count,
		AssertScene.FAIL_MESSAGE
	])
