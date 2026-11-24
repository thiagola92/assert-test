extends EditorContextMenuPlugin


func _popup_menu(paths: PackedStringArray) -> void:
	if paths.size() != 1:
		return
	
	var path: String = ProjectSettings.globalize_path(paths[0])
	
	if not DirAccess.dir_exists_absolute(path):
		return
	
	add_context_menu_item(
		"Build Assert Suit",
		_on_pressed,
		load("res://addons/assert_test/editor/filesystem_menu/filesystem_menu.svg")
	)


func _on_pressed(paths: Array) -> void:
	if paths.size() != 1:
		return
	
	var path: String = ProjectSettings.globalize_path(paths[0])
	
	if not DirAccess.dir_exists_absolute(path):
		return
	
	# Force the action: Scene > New Scene.
	var b := EditorInterface.get_base_control()
	var t := b.find_child("*EditorTitleBar*", true, false)
	var p: PopupMenu = t.find_children("*", "PopupMenu", true, false)[0]
	p.id_pressed.emit(p.get_item_id(0))
	
	# Set root node.
	EditorInterface.add_root_node(AssertReport.new())
