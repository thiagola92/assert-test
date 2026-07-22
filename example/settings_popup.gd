extends Popup


var music_volume: int = 100


func set_music_volume(volume: int) -> void:
	music_volume = volume


func get_music_volume() -> int:
	return music_volume
