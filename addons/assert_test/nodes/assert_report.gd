@icon("res://addons/assert_test/nodes/assert_report.svg")
@tool
class_name AssertReport
extends AssertSuit
## Used to display the report from [AssertSuit] and all [AssertScene] children.


## Flags to be used in [member report_style] to configure how to report the result.
enum Report {
	## Should print the final result (how many passed and failed).
	RESULT = 1,
	
	## Should print the passed tests.
	OK = 2,
	
	## Should print the failed tests.
	FAIL = 4,
	
	## Should wait all tests to finish and print the passed tests first.
	OK_FIRST = 8,
	
	## Should wait all tests to finish and print following top-down order (children order).
	## [br][br]
	## [b]Note[/b]: [enum Report.OK_FIRST] must be disabled.
	TOP_DOWN = 16,
}

## Defines how the report should be showed.
@export_flags(
	"Report result:%s" % Report.RESULT,
	"Report ok:%s" % Report.OK,
	"Report fail:%s" % Report.FAIL,
	"Report ok first:%s" % Report.OK_FIRST,
	"Report top-down:%s" % Report.TOP_DOWN,
) var report_style: int = 7


func _ready() -> void:
	scene_reporting.connect(_on_scene_reporting)
	suit_reporting.connect(_on_suit_reporting)
	
	super()


func _on_scene_reporting(scene: AssertScene) -> void:
	if report_style & Report.OK_FIRST == Report.OK_FIRST:
		return
	
	if report_style & Report.TOP_DOWN == Report.TOP_DOWN:
		return
	
	if scene.is_ok() and (report_style & Report.OK != Report.OK):
		return
	
	if not scene.is_ok() and (report_style & Report.FAIL != Report.FAIL):
		return
	
	scene.print_report()


func _on_suit_reporting() -> void:
	if report_style & Report.OK_FIRST == Report.OK_FIRST:
		_print_ok_first()
	elif report_style & Report.TOP_DOWN == Report.TOP_DOWN:
		_print_top_down()
	
	if report_style & Report.RESULT == Report.RESULT:
		print_report()
	
	# Slowly quit to give time to print out the result.
	get_tree().create_timer(1).timeout.connect(
		func(): get_tree().quit.call_deferred(fail_count)
	)


func _print_ok_first() -> void:
	for scene in get_children():
		if scene is AssertScene:
			if scene.is_ok() and (report_style & Report.OK == Report.OK):
				scene.print_report()
	
	for scene in get_children():
		if scene is AssertScene:
			if not scene.is_ok() and (report_style & Report.FAIL == Report.FAIL):
				scene.print_report()


func _print_top_down() -> void:
	for scene in get_children():
		if scene is AssertScene:
			if scene.is_ok() and (report_style & Report.OK == Report.OK):
				scene.print_report()
			
			if not scene.is_ok() and (report_style & Report.FAIL == Report.FAIL):
				scene.print_report()
