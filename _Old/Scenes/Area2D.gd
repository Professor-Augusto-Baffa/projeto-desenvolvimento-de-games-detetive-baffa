extends Area2D

var entered = false

func _on_body_entered(body: PhysicsBody2D):
	if body.name == "Player":
		entered = true  # Corrigir o operador de atribuição de == para =

func _process(delta):
	if entered == true:
		if Input.is_action_pressed("ui_accept"):
			LevelManager.load_level(2)


func _on_body_exited(body):
	entered = false
