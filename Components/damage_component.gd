extends Node2D

var flash: bool = false
var parent: Node2D

@export var immunity_time: float = 0.2

func _ready():
	parent = get_parent()
	assert("hp" in parent, "ERROR: Attempt to load DamageComponent in Node without HP")
	
	parent.material = self.material

func damage(x: int):
	print("DAMAGE - ", parent)
	if $ImmunityTimer.time_left > 0:
		return
		
	parent.hp -= x
	
	if parent.hp <= 0:
		if "death" in parent:
			parent.death()
			
		else:
			parent.queue_free()
	
	else:
		$ImmunityTimer.start(immunity_time)
		$HitflashTimer.start(0.1)
		if "hurt" in parent:
			parent.hurt()
			
		if "incapacitated" in parent:
			parent.incapacitated = true
			
		if "immune" in parent:
			parent.immune = true
	
func _on_immunity_timer_timeout():
	print("NOT IMMUNE")
	if "incapacitated" in parent:
		parent.incapacitated = false
		
	if "immune" in parent:
		parent.immune = false

func _on_hitflash_timer_timeout():
	if $ImmunityTimer.time_left <= 0:
		flash = false
		
	else:
		flash = !flash
		$HitflashTimer.start(0.1)
		
	parent.material.set_shader_parameter("active", flash)
