@icon("res://addons/assert_test/assert_report.svg")
@tool
class_name AssertReport
extends AssertSuit


const REPORT_RESULT: int = 1

const REPORT_OK: int = 2

const REPORT_FAIL: int = 4

const REPORT_OK_FIRST: int = 8

## Defines how the report should be showed.
@export_flags(
	"Report result:1",
	"Report ok:2",
	"Report fail:4",
	"Report ok first:8"
) var report_style: int = 7


func _ready() -> void:
	scene_reporting.connect(_on_scene_reporting)
	suit_reporting.connect(_on_suit_reporting)
	
	super()


func _on_scene_reporting(scene: AssertScene) -> void:
	if report_style & REPORT_OK_FIRST == REPORT_OK_FIRST:
		return
	
	if scene.is_ok() and (report_style & REPORT_OK != REPORT_OK):
		return
	
	if not scene.is_ok() and (report_style & REPORT_FAIL != REPORT_FAIL):
		return
	
	scene.print_report()


func _on_suit_reporting() -> void:
	if report_style & REPORT_OK_FIRST == REPORT_OK_FIRST:
		# Print ok.
		for scene in get_children():
			if scene is AssertScene:
				if scene.is_ok() and (report_style & REPORT_OK == REPORT_OK):
					scene.print_report()
		
		# Print fail.
		for scene in get_children():
			if scene is AssertScene:
				if not scene.is_ok() and (report_style & REPORT_FAIL == REPORT_FAIL):
					scene.print_report()
	
	if report_style & REPORT_RESULT == REPORT_RESULT:
		print_report()
	
	get_tree().create_timer(1).timeout.connect(_quit)


func _quit() -> void:
	get_tree().quit.call_deferred(fail_count)
