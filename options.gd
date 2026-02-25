extends Control

var settings = {
	"speaker" = "Default",
	"vac" = "Default"
}

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		%OptionsMenu.visible = false

func _ready() -> void:
	for device in AudioServer.get_output_device_list():
		%SpeakerDropdown.add_item(device)
		%VacDropdown.add_item(device)
	load_user_settings()

func _on_speaker_selected(index: int) -> void:
	settings["speaker"] = AudioServer.get_output_device_list()[index]
	save_user_settings()

func _on_vac_selected(index: int) -> void:
	settings["vac"] = AudioServer.get_output_device_list()[index]
	save_user_settings()

func load_user_settings() -> void:
	if !FileAccess.file_exists("user://user_data.json"):
		print("no user data")
		return
	var user_file = FileAccess.open("user://user_data.json", FileAccess.READ)
	while user_file.get_position() < user_file.get_length():
		var json_string = user_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var user_data = json.data
		if AudioServer.get_output_device_list().has(user_data["speaker"]):
			settings["speaker"] = user_data["speaker"]
		if AudioServer.get_output_device_list().has(user_data["vac"]):
			settings["vac"] = user_data["vac"]
	%VacDropdown.selected = AudioServer.get_output_device_list().find(settings["vac"])
	%SpeakerDropdown.selected = AudioServer.get_output_device_list().find(settings["speaker"])
	AudioServer.output_device = settings["speaker"]

func save_user_settings():
	var user_save = FileAccess.open("user://user_data.json", FileAccess.WRITE)
	user_save.store_line(JSON.stringify(settings))
