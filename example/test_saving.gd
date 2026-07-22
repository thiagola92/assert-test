extends MarginContainer


func _ready() -> void:
	# Preparing quit after this function finish.
	get_tree().quit.call_deferred(0)
	
	$SettingsPopup.set_music_volume(50)
	assert($SettingsPopup.get_music_volume() == 50)
