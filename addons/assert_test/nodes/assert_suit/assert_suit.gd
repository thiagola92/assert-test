@icon("./assert_suit.svg")
@tool
class_name AssertSuit
extends Node
## Used to start children [AssertScene]/[AssertSuit] and store their final result.


## Emitted when the suit finish.
signal finished

## Emitted when a scene is reporting that it finished.
signal scene_reporting(scene: AssertScene)

## Emitted when a suit is reporting that it finished.
signal suit_reporting(suit: AssertSuit)

## It will be printed together with the suit result.
@export var description: String = ""

## Set to [code]true[/code] if this suit should be ignored.
@export var ignore: bool = false

## How many tests finished without error.
var success_count: int = 0

## How many tests finished with error (halting count as error).
var fail_count: int = 0

## How many tests existed.
var tests_count: int = 0


func _get_configuration_warnings() -> PackedStringArray:
	for c in get_children():
		if c is not AssertScene and c is not AssertSuit:
			return ["All nodes children should be AssertScene/AssertSuit"]
	return []


func start() -> void:
	for c in get_children():
		if c is AssertScene:
			if c.ignore:
				continue
			
			c.finished.connect(_on_assert_scene_finished.bind(c))
			c.start()
			
			tests_count += 1
		elif c is AssertSuit:
			if c.ignore:
				continue
			
			c.finished.connect(_on_assert_suit_finished.bind(c))
			c.start()
			
			tests_count += 1
	
	if (success_count + fail_count) == tests_count:
		finished.emit()


func is_ok() -> bool:
	return fail_count == 0


func get_report() -> String:
	return "(%s %s, %s %s) [b]%s[/b]" % [
		success_count,
		AssertScene.OK_MESSAGE,
		fail_count,
		AssertScene.FAIL_MESSAGE,
		description,
	]


func _on_assert_scene_finished(scene: AssertScene) -> void:
	if scene.is_ok():
		success_count += 1
	else:
		fail_count += 1
	
	scene_reporting.emit(scene)
	
	if (success_count + fail_count) == tests_count:
		finished.emit()


func _on_assert_suit_finished(suit: AssertSuit) -> void:
	if suit.is_ok():
		success_count += 1
	else:
		fail_count += 1
	
	suit_reporting.emit(suit)
	
	if (success_count + fail_count) == tests_count:
		finished.emit()
