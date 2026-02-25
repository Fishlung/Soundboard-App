extends Control

var edited_button

func _ready() -> void:
	if !FileAccess.file_exists("user://buttons.json"):
		print("no save data")
		return
	var button_save = FileAccess.open("user://buttons.json", FileAccess.READ)
	while button_save.get_position() < button_save.get_length():
		var json_string = button_save.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var button_data = json.data
		if !button_data.has("path"):
			printerr("No path found for button. Skipping.")
			continue
		
		var button_name = "Untitled Button"
		var button_volume = 1
		
		if button_data.has("name"):
			button_name = button_data["name"]
		if button_data.has("volume"):
			button_volume = button_data["volume"]
		add_button(button_data["path"], button_name, button_volume)
	save_buttons()


func _on_import_pressed() -> void:
	%FileDialog.popup()

func _on_stop_all_pressed() -> void:
	for child in %SoundOptions.get_children():
		if child is SoundButton:
			child.sound_file.stop()

func _file_selected(path: String) -> void:
	var saved_sounds = DirAccess.open("user://")
	var sound_name = (path.get_slice("/", path.get_slice_count("/")-1))
	var sound_path =  OS.get_user_data_dir() + "/" + sound_name
	saved_sounds.copy(path, sound_path)
	add_button(sound_path, sound_name, 1)
	save_buttons()

func add_button(path: String, Sound_Name: String, Sound_Volume: float):
	var new_button = load("res://sound_button.tscn").instantiate()
	new_button.sound_name = Sound_Name
	new_button.sound_path = path
	new_button.volume = Sound_Volume
	new_button.right_clicked.connect(on_button_right_click)
	%SoundContainer.add_child(new_button)

func save_buttons():
	var button_save = FileAccess.open("user://buttons.json", FileAccess.WRITE)
	for button in %SoundContainer.get_children():
		var button_data = button.save()
		button_save.store_line(JSON.stringify(button_data))

func on_button_right_click(button: SoundButton):
	if %SoundOptions.visible:
		%SoundOptions.visible = false
		return
	edited_button = button
	%SoundOptions.visible = true
	%NameEditor.text = button.sound_name
	%VolumeSlider.value = button.volume

func _on_name_editor_submitted(new_text: String) -> void:
	edited_button.sound_name = new_text
	save_buttons()


func _on_volume_slider_value_changed(value: float) -> void:
	edited_button.volume = value
	save_buttons()
