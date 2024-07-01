extends Area2D


@onready var player:= $Player

var elapsed_time = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("interact") and player.global_position.x > $A.global_position.x and player.global_position.x < $B.global_position.x and player.global_position.y > $A.global_position.y and player.global_position.y < $B.global_position.y:
		elapsed_time += delta
		
	else:
		elapsed_time = 0
		
	if elapsed_time >= 5.0:
		Global.goto_scene("res://Scenes/fim.tscn")
