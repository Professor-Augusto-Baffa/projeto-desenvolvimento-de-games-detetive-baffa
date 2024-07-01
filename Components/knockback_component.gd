extends Node2D

@onready var parent: Node2D = get_parent()

func knockback(origin_global_position: Vector2, strength: float) -> void:
	if "knockback_queue" in parent:
		parent.knockback_queue += (parent.global_position - origin_global_position).normalized() * strength
		
	
