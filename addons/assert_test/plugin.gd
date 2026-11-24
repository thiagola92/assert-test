@tool
extends EditorPlugin


const FilesystemMenu: GDScript = preload(
	"res://addons/assert_test/editor/filesystem_menu/filesystem_menu.gd"
)

var _filesystem_menu: FilesystemMenu


func _enter_tree():
	_filesystem_menu = FilesystemMenu.new()
	
	add_context_menu_plugin(
		EditorContextMenuPlugin.CONTEXT_SLOT_FILESYSTEM,
		_filesystem_menu
	)


func _exit_tree():
	if is_instance_valid(_filesystem_menu):
		remove_context_menu_plugin(_filesystem_menu)
		_filesystem_menu = null
