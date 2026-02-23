extends Control
class_name SoundButton

signal right_clicked

@onready var sound_file = %AudioStreamPlayer
var sound_name: String:
	set (new_name):
		sound_name = new_name
		self.text = sound_name
var sound_path: String:
	set(new_path):
		var filetype = new_path.get_slice(".", new_path.get_slice_count(".") - 1).to_lower()
		var stream 
		match filetype:
			"wav":
				stream = AudioStreamWAV.load_from_file(new_path)
			"ogg":
				stream = AudioStreamOggVorbis.load_from_file(new_path)
			"mp3":
				stream = AudioStreamMP3.load_from_file(new_path)
		%AudioStreamPlayer.stream = stream
		sound_path = new_path

func _on_pressed() -> void:
	if Input.is_action_just_released("left_click"):
		if sound_file.playing:
			sound_file.stop()
			return
		sound_file.play()
	elif Input.is_action_just_released("right_click"):
		right_clicked.emit(self)

func save():
	var save_data = {
		"name" = sound_name,
		"path" = sound_path,
	}
	return save_data
