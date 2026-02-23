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
		add_button(button_data["name"], button_data["path"])


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
	add_button(sound_name, sound_path)
	save_buttons()

func add_button(Sound_Name: String, path: String):
	var new_button = load("res://sound_button.tscn").instantiate()
	new_button.sound_name = Sound_Name
	new_button.sound_path = path
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

func _on_name_editor_submitted(new_text: String) -> void:
	edited_button.sound_name = new_text
	save_buttons()
