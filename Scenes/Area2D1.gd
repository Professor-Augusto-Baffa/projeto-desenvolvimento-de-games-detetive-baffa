extends Area2D

var entered = false

func _on_area_entered(area):
	entered = true

func _on_area_exited(area):
	entered = true

func _process(_delta):
	if entered == true:
		print('entrou')
		if Input.is_action_just_pressed("jump"):
			print('pulei dentro da area2d')
			get_tree().change_scene_to_file("res://Scenes/mundo_2.tscn")
