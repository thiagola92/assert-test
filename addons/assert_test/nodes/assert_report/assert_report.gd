@icon("./assert_report.svg")
@tool
class_name AssertReport
extends AssertSuit
## Used to display the report from this [AssertSuit] and
## all it [AssertScene]/[AssertSuit] children through terminal.
##
## It exit after reporting and the exit code it's zero if no error happened.


## Flags to be used in [member report_show] to configure what to show in the report.
enum ReportShow {
	## Print the final result (how many passed and failed).
	RESULT = 1,
	
	## Print the passed tests.
	OK = 2,
	
	## Print the failed tests.
	FAIL = 4,
}

## Flags to be used in [member report_order] to configure the report order.
enum ReportOrder {
	## Print as soon as possible.
	ASAP = 0,
	
	## Print the passed tests first.
	## [br][br]
	## [b]Note[/b]: It will wait all tests to finish before starting printing.
	OK_FIRST = 1,
	
	## Print following top-down order (children order).
	## [br][br]
	## [b]Note[/b]: It will wait all tests to finish before starting printing.[br]
	TOP_DOWN = 2,
}

## Defines what the report should show.
@export_flags(
	"Result:%s" % ReportShow.RESULT,
	"Ok:%s" % ReportShow.OK,
	"Fail:%s" % ReportShow.FAIL,
) var report_show: int = 7

## Defines in which order it will show the results.
@export var report_order: ReportOrder = 0


func _ready() -> void:
	scene_reporting.connect(_on_scene_reporting)
	suit_reporting.connect(_on_suit_reporting)
	finished.connect(_on_finished)
	
	# Prevent starting automatically when the parent is an AssertSuit.
	if get_parent() is AssertSuit:
		return
	
	# Prevent starting automatically when running inside the editor (e.g. EditorDock).
	if Engine.is_editor_hint():
		return
	
	start()


func _on_scene_reporting(scene: AssertScene) -> void:
	if report_order == ReportOrder.OK_FIRST:
		return
	
	if report_order == ReportOrder.TOP_DOWN:
		return
	
	if scene.is_ok() and (report_show & ReportShow.OK != ReportShow.OK):
		return
	
	if not scene.is_ok() and (report_show & ReportShow.FAIL != ReportShow.FAIL):
		return
	
	print_rich(scene.get_report())


func _on_suit_reporting(suit: AssertSuit) -> void:
	if report_order == ReportOrder.OK_FIRST:
		return
	
	if report_order == ReportOrder.TOP_DOWN:
		return
	
	if suit.is_ok() and (report_show & ReportShow.OK != ReportShow.OK):
		return
	
	if not suit.is_ok() and (report_show & ReportShow.FAIL != ReportShow.FAIL):
		return
	
	print_rich(suit.get_report())


func _on_finished() -> void:
	if report_order == ReportOrder.OK_FIRST:
		_print_ok_first()
	elif report_order == ReportOrder.TOP_DOWN:
		_print_top_down()
	
	# Prevent reporting and quitting because it's the parent responsibility.
	if get_parent() is AssertSuit:
		return
	
	if report_show & ReportShow.RESULT == ReportShow.RESULT:
		print_rich(get_report())
	
	# Slowly quit to give time to print out the result.
	get_tree().create_timer(1).timeout.connect(
		func(): get_tree().quit(fail_count)
	)


func _print_ok_first() -> void:
	for c in get_children():
		if c is AssertScene:
			if c.ignore:
				continue
			
			if c.is_ok() and (report_show & ReportShow.OK == ReportShow.OK):
				print_rich(c.get_report())
		elif c is AssertSuit:
			if c.ignore:
				continue
			
			if c.is_ok() and (report_show & ReportShow.OK == ReportShow.OK):
				print_rich(c.get_report())
	
	for c in get_children():
		if c is AssertScene:
			if c.ignore:
				continue
			
			if not c.is_ok() and (report_show & ReportShow.FAIL == ReportShow.FAIL):
				print_rich(c.get_report())
		elif c is AssertSuit:
			if c.ignore:
				continue
			
			if not c.is_ok() and (report_show & ReportShow.FAIL == ReportShow.FAIL):
				print_rich(c.get_report())


func _print_top_down() -> void:
	for c in get_children():
		if c is AssertScene:
			if c.ignore:
				continue
			
			if c.is_ok() and (report_show & ReportShow.OK == ReportShow.OK):
				print_rich(c.get_report())
			
			if not c.is_ok() and (report_show & ReportShow.FAIL == ReportShow.FAIL):
				print_rich(c.get_report())
		elif c is AssertSuit:
			if c.ignore:
				continue
			
			if c.is_ok() and (report_show & ReportShow.OK == ReportShow.OK):
				print_rich(c.get_report())
			
			if not c.is_ok() and (report_show & ReportShow.FAIL == ReportShow.FAIL):
				print_rich(c.get_report())
