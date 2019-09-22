extends Node2D


func appear():
	$Timer.start()
	set_physics_process(true)
	
func _physics_process(delta):
	$AnimationPlayer.play("teleport_smoke");

func _on_Timer_timeout():
	queue_free()
