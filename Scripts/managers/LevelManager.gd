extends Node

var levels : Array[LevelData]

var main_scene : Node2D = null
var loaded_level : Level = null

func unload_level() -> void:
	if is_instance_valid(loaded_level):
		loaded_level.queue_free()
		
	loaded_level = null

func load_level(level_id: int) -> void:
	print("Loading level: %d" % level_id) 
	unload_level()
	
	var level_data = get_level_data_by_id(level_id)
	
	if not level_data:
		return 
		
	var level_path = "res://Scenes/%s.tscn" % level_data.level_path
	var level_resource = load(level_path)	
	
	if level_resource:
		loaded_level = level_resource.instantiate()
		if is_instance_valid(main_scene):
			main_scene.add_child(loaded_level)
		else:
			print("Main scene is not valid")
	else:
		print("Level does not exist")
	
func get_level_data_by_id(id: int) -> LevelData:
	var level_to_return : LevelData = null
	for level : LevelData in levels:
		if level.level_id == id:
			level_to_return = level
	return level_to_return
