extends EditorContextMenuPlugin


func _popup_menu(paths: PackedStringArray) -> void:
	if paths.size() != 1:
		return
	
	var path: String = ProjectSettings.globalize_path(paths[0])
	
	if not DirAccess.dir_exists_absolute(path):
		return
	
	add_context_menu_item("Build Assert Suit", _on_pressed)


func _on_pressed(paths: Array) -> void:
	if paths.size() != 1:
		return
	
	var path: String = ProjectSettings.globalize_path(paths[0])
	
	if not DirAccess.dir_exists_absolute(path):
		return
	
	pass
