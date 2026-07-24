@icon("res://addons/assert_test/assert_suit.svg")
@tool
class_name AssertSuit
extends Node


signal scene_reporting(scene: AssertScene)

signal suit_reporting

enum ReportStyle {
	## Hide suit and tests reports.
	ALL_HIDE,
	
	## Hide tests reports.
	OK_FAIL_HIDE,
	
	## Show tests reports, as soon as possible.
	OK_FAIL_NOW,
	
	## Show tests reports, respecting scene order.
	OK_FAIL_ORDER,
	
	## Show success reports first, then show fail reports.
	OK_FIRST_FAIL_LATER,
	
	## Hide success reports, show fail reports.
	OK_HIDE_FAIL_LATER,
	
	## Show as soon as possible fail reports.
	OK_HIDE_FAIL_NOW,
}

@export var report_style: ReportStyle = ReportStyle.OK_FAIL_NOW

var success_count: int = 0

var fail_count: int = 0

var finished_order: Array[AssertScene] = []

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


func _on_assert_scene_finished(scene: AssertScene) -> void:
	finished_order.append(scene)
	
	if scene.is_ok():
		success_count += 1
	else:
		fail_count += 1
	
	scene_reporting.emit(scene)
	
	if (success_count + fail_count) == tests_count:
		suit_reporting.emit()


func _on_scene_reporting(scene: AssertScene) -> void:
	if report_style == ReportStyle.OK_FAIL_NOW:
		scene.print_report()
	elif report_style == ReportStyle.OK_HIDE_FAIL_NOW:
		if not scene.is_ok():
			scene.print_report()


func _on_suit_reporting() -> void:
	if report_style == ReportStyle.OK_FIRST_FAIL_LATER:
		for scene in finished_order:
			if scene.is_ok():
				scene.print_report()
		for scene in finished_order:
			if not scene.is_ok():
				scene.print_report()
	elif report_style == ReportStyle.OK_HIDE_FAIL_LATER:
		for scene in finished_order:
			if not scene.is_ok():
				scene.print_report()
	
	if report_style != ReportStyle.ALL_HIDE:
		print_rich("%s %s, %s %s" % [
			success_count,
			AssertScene.OK_MESSAGE,
			fail_count,
			AssertScene.FAIL_MESSAGE
		])
