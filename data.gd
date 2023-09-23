extends Node


@export var file_path := "user://data.dat"

var data := {first_time = true}


func _init() -> void:
	data = load_data()


func load_data() -> Dictionary:
	if FileAccess.file_exists(file_path):
		var file := FileAccess.open(file_path, FileAccess.READ)
		var error := FileAccess.get_open_error()
		if error == OK:
			return file.get_var()
		else:
			OS.alert("Unable to load data.\n" + error_string(error))
			return data
	else:
		save_data(data)
		return data


@warning_ignore("shadowed_variable")
func save_data(data: Dictionary) -> void:
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	var error := FileAccess.get_open_error()
	if error == OK:
		file.store_var(data)
	else:
		OS.alert("Unable to save data.\n" + error_string(error))
