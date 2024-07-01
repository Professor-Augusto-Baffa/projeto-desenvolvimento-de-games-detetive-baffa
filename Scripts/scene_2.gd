extends Node2D


func _ready():
	$Boss.player = $NewPlayer
	$Boss/Arm.player = $NewPlayer

func _process(delta):
	if Input.is_action_just_pressed("debug"):
		Global.goto_scene("res://Scenes/scene_1.tscn")
		
	if Input.is_action_just_pressed("interact"):
		$Boss/Arm.shoot(5)
