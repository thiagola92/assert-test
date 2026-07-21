class_name AssertScene
extends Node
## Used to assert that a scene is working correctly.
##
## It spawn a process and thread, the process execute the target [member scene] and
## the thread monitor the process stderr. If at the end of the process no error message
## was generate, we assume that no error happened.
## [br][br]
## Use the built-in [method @GDScript.assert] to test for errors inside the scenes and
## remember to quit the scene with [code]get_tree().quit(0)[/code].
## [br][br]
## [b]Warning[/b]: This class is slow because it uses process, threads, mutex. 
## To avoid unnecessary performance overhead, make sure to test as much you can in one scene.


const _KILLED_MESSAGE = "\nScene killed after exceeding time limit, \
to avoid this remember to end scene with [code]get_tree().quit(0)[/code]. \
\nAs result of killing it, the scene stderr could be incomplete."

@export var message: String = ""

@export var scene: PackedScene

@export var timeout: int = 60

@export var enabled: bool = true

var _thread: Thread = Thread.new()

var _mutex: Mutex = Mutex.new()

var _pid: int = -1

var _timer: Timer = Timer.new()

var errors: String = ""

var killed: bool = false


func _ready() -> void:
	if not enabled:
		return
	
	_timer.one_shot = true
	
	add_child(_timer)
	_timer.timeout.connect(_on_timer_timeout)
	_thread.start(_run_scene)
	_timer.start(timeout)


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
		errors += stderr.get_as_text()
	
	_mutex.lock()
	
	_pid = -1
	
	if not _timer.is_stopped():
		_timer.start.call_deferred(0.01)
	
	_mutex.unlock()


func _on_timer_timeout() -> void:
	_mutex.lock()
	
	if _pid >= 0:
		OS.kill(_pid)
		killed = true
	
	_mutex.unlock()
	
	if _thread.is_started():
		_thread.wait_to_finish()
	
	print_report()


func print_report() -> void:
	var result: String
	var title: String = "<UNNAMED>" if message.is_empty() else message
	
	if errors.is_empty() and not killed:
		result = "[color=green]OK[/color]"
		
		print_rich("(%s) [b]%s[/b]" % [result, title])
	else:
		result = "[color=red]FAIL[/color]"
		var lines: Array = errors.split("\n")
		var report: String = "\n\t".join(lines)
		var kill_msg: String = _KILLED_MESSAGE if killed else ""
		
		print_rich("(%s) [b]%s[/b] [u]%s[/u]\n\t%s" % [result, title, kill_msg, report])
