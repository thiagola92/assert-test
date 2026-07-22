extends MarginContainer


func _ready() -> void:
	# Preparing to quit after this function finish.
	get_tree().quit.call_deferred(0)
	
	var initial_volume: int = $SettingsPopup.get_music_volume()
	var desired_volume: int = 50

	assert(initial_volume != desired_volume, "Volumes should be different for this test")

	$SettingsPopup.set_music_volume(desired_volume)
	var new_volume: int = $SettingsPopup.get_music_volume()

	assert(new_volume == desired_volume, "Volume did not changed")
