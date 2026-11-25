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
	
	var root_node = _create_nodes(path)
	
	if root_node == null:
		return
	
	# Force the action: Scene > New Scene.
	var b := EditorInterface.get_base_control()
	var t := b.find_child("*EditorTitleBar*", true, false)
	var p: PopupMenu = t.find_children("*", "PopupMenu", true, false)[0]
	p.id_pressed.emit(p.get_item_id(0))
	
	# Set root node.
	EditorInterface.add_root_node(root_node)


func _create_nodes(dirpath: String, owner: AssertReport = null) -> AssertReport:
	var dir := DirAccess.open(dirpath)
	
	if dir == null:
		return null
	
	var parts: PackedStringArray = dirpath.split("/", false)
	
	if parts.is_empty():
		return null
	
	var dirname := parts[-1]
	var parent := AssertReport.new()
	parent.name = dirname.to_pascal_case()
	
	# If nobody declared itself as owner, you are the owner.
	# Future recursion will use you as the owner.
	if owner == null:
		owner = parent
	
	dir.list_dir_begin()
	
	var current: String = dir.get_next()
	
	while current != "":
		var path := dirpath.path_join(current)
		
		if dir.current_is_dir():
			var assert_report: AssertReport = _create_nodes(path, owner)
			
			if assert_report != null:
				parent.add_child(assert_report)
				assert_report.set_owner.call_deferred(owner)
		elif current.get_extension() == "tscn":
			var assert_scene: AssertScene = AssertScene.new()
			assert_scene.name = current.get_file().get_slice(".", 0).to_pascal_case()
			
			parent.add_child(assert_scene)
			assert_scene.set_owner.call_deferred(owner)
		
		current = dir.get_next()
	
	return parent
