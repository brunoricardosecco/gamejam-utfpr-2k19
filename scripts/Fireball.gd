extends KinematicBody2D

# gravity
var _gravity = 0



#movement
var _movement = Vector2()

func shoot(directional_force, gravity):
	_movement = directional_force
	_gravity = gravity
	set_physics_process(true)
	
	
func _physics_process(delta) :
	_movement.x += delta
	
	move_and_collide(_movement)


func _on_Area2D_body_entered(body):
	if (body.get_name() != "Vigilante") :
		queue_free()

