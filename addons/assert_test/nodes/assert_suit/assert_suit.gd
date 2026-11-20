@icon("./assert_suit.svg")
@tool
class_name AssertSuit
extends Node
## Used to run multiple [AssertScene] and store the final result.


## Emitted when a scene is reporting that it finished.
signal scene_reporting(scene: AssertScene)

## Emitted when the suit is reporting that it finished.
signal suit_reporting

## How many tests finished without error.
var success_count: int = 0

## How many tests finished with error (halting count as error).
var fail_count: int = 0

## How many tests existed.
var tests_count: int = 0


func _ready() -> void:
	start()


func _get_configuration_warnings() -> PackedStringArray:
	for c in get_children():
		if c is not AssertScene:
			return ["All nodes children should be AssertScene"]
	return []


func get_report() -> String:
	return "%s %s, %s %s" % [
		success_count,
		AssertScene.OK_MESSAGE,
		fail_count,
		AssertScene.FAIL_MESSAGE
	]


func start() -> void:
	# Prevent activating inside the editor (e.g. EditorDock).
	if Engine.is_editor_hint():
		return
	
	for c in get_children():
		if c is AssertScene:
			if c.ignore:
				continue
			
			c.finished.connect(_on_assert_scene_finished.bind(c))
			c.start()
			
			tests_count += 1


func _on_assert_scene_finished(scene: AssertScene) -> void:
	if scene.is_ok():
		success_count += 1
	else:
		fail_count += 1
	
	scene_reporting.emit(scene)
	
	if (success_count + fail_count) == tests_count:
		suit_reporting.emit()
