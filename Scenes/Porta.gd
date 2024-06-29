extends Area2D

var porta2 = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if porta2:
		if Input.is_action_pressed("ui_accept"):
			LevelManager.load_level(3)


func _on_body_entered(body):
	print("ativei porta 2")
	if body.name == "Player":
		porta2 = true 


func _on_body_exited(body):
	porta2 = false
