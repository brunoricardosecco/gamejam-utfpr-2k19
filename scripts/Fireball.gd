extends KinematicBody2D

# gravity
var _gravity = 0



#movement
var _movement = Vector2()
var _direction
var collided = false;

func shoot(directional_force, gravity, direction):
	_movement = directional_force
	_direction = direction
	set_physics_process(true)
	
	
func _physics_process(delta) :
	_movement.x += delta
	if (_direction == 1):
		if collided:
			$AnimationPlayer.play("fireball_explosion")
		else:
			$AnimationPlayer.play("fireball_idle")
	elif (_direction == -1):
		$Sprite.set_flip_h(true)
		if collided:
			$AnimationPlayer.play("fireball_explosion")
		else:
			$AnimationPlayer.play("fireball_idle")
	move_and_collide(_movement)


func _on_Area2D_body_entered(body):
	if (body.get_name() != "Vigilante") :
		collided = true
		_movement = Vector2(0,0)
		move_and_collide(_movement)
		$Timer.start()
	
	if(body.get_name() != 'Parede' && body.get_name() != 'plataformas' && body.get_name() != 'NPC'):
		if (body.ENEMY) :
			body.life -= 1
			if body.life == 0:
				body.queue_free()
func _on_Timer_timeout():
		queue_free()
