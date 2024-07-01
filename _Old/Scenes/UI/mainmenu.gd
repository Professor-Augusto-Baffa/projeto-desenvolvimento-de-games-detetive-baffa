class_name MainMenu
extends Control


func _on_play_button_pressed():
	$MenuMusic.stop()
	Global.goto_scene("res://Scenes/scene_1.tscn")
	#LevelManager.load_level(1)
	deactivate()

func _on_quit_button_pressed():
	get_tree().quit()

func deactivate():
	hide()
	set_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)

func activate():
	show()
	set_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)
