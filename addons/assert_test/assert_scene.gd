@icon("res://addons/assert_test/assert_scene.svg")
class_name AssertScene
extends Node
## Used to assert that a scene is working correctly.
##
## It spawn a process and thread, the process execute the target [member scene] and
## the thread monitor the process stderr. If at the end of the process no error message
## was generate, we assume that no error happened.
## [br][br]
## Use the built-in [method @GDScript.assert] to test for errors inside the scenes and
## remember to quit the scene with [code]get_tree().quit.call_deferred(0)[/code].
## [br][br]
## [b]Warning[/b]: This class is slow because it uses process, threads, mutex. 
## To avoid unnecessary performance overhead, make sure to test as much you can in one scene.


## Emitted when the test finish.
signal finished(ok: bool)

const OK_MESSAGE = "[color=green]OK[/color]"

const FAIL_MESSAGE = "[color=red]FAIL[/color]"

const _UNDEFINED = "<UNDEFINED>"

const _HALTED_MESSAGE = "--- [u]Scene halted after exceeding time limit[/u]"

## Message to be printed together with the test result.
@export var message: String = ""

## Scene to be tested.
@export var scene: PackedScene

## How long to wait for a scene to end.
@export var timeout: int = 60

## If [code]true[/code], the test will start when the node is "ready".
@export var autostart: bool = true

## If [code]true[/code], the test will print report as soon as possible.
@export var autoprint: bool = true

var _thread: Thread = Thread.new()

var _mutex: Mutex = Mutex.new()

var _pid: int = -1

var _timer: Timer = Timer.new()

var _halted: bool = false

var _errors: String = ""


func _ready() -> void:
	_timer.one_shot = true
	
	add_child(_timer)
	_timer.timeout.connect(_on_timer_timeout)
	
	if autostart:
		start()


func start() -> void:
	_thread.start(_run_scene)
	_timer.start(timeout)


func print_report() -> void:
	print_rich(_get_report())


func is_ok() -> bool:
	return _errors.is_empty() and not _halted


func _run_scene() -> void:
	assert(scene)
	
	var root_path: String = ProjectSettings.globalize_path("res://")
	var exe_path: String = OS.get_executable_path()
	var res_path: String = scene.resource_path
	var args: Array = [
		"--no-header", # Do not print engine details at start up.
		"--headless", # Do not start editor.
		"--quiet", # Ignore stdout (stderr continue to work).
		"--ignore-error-breaks", # Prevent assert() from pausing.
		"--path", # Root of the project.
		root_path,
		"--scene", # Start specific scene.
		res_path,
	]
	
	_monitor_process(OS.execute_with_pipe(exe_path, args, false))


func _monitor_process(pipe: Dictionary) -> void:
	assert(not pipe.is_empty())
	
	var stderr: FileAccess = pipe["stderr"]
	_pid = pipe["pid"]
	
	while OS.is_process_running(_pid):
		# Can show error in the debug if the process is halted during the operation.
		_errors += stderr.get_as_text()
	
	_mutex.lock()
	
	_pid = -1
	
	if not _timer.is_stopped():
		_timer.start.call_deferred(0.01)
	
	_mutex.unlock()


func _on_timer_timeout() -> void:
	_mutex.lock()
	
	if _pid >= 0:
		OS.kill(_pid)
		_halted = true
	
	_mutex.unlock()
	
	if _thread.is_started():
		_thread.wait_to_finish()
	
	if autoprint:
		print_report()
	
	finished.emit(is_ok())


func _get_report() -> String:
	var result: String
	var msg: String = _UNDEFINED if message.is_empty() else message
	
	if is_ok():
		return "(%s) [b]%s[/b]" % [OK_MESSAGE, msg]
	
	var lines: Array = _errors.split("\n")
	var report: String = "\n\t".join(lines)
	var kill_msg: String = _HALTED_MESSAGE if _halted else ""
	
	return "(%s) [b]%s[/b] %s\n\t%s" % [FAIL_MESSAGE, msg, kill_msg, report]
