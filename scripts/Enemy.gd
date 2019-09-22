extends KinematicBody2D

onready var Vigilante = get_parent().get_node("Vigilante")

const SPEED = 50
const FLOOR = Vector2(0,-1)
const MAXLIFE = 3
const ENEMY = true

var life = MAXLIFE

var vel = Vector2(0,0)
#var velocity = Vector2()

var direction = 1

var grav = 1000
var max_grav = 3000

func _ready() :
	$AnimationPlayer.play("idle")

func _physics_process(delta):
	if Vigilante.position.x+100 > position.x && Vigilante.position.x+35 < position.x:
		vel.x = -50
		$Sprite.set_flip_h(true)
		$AnimationPlayer.play("walk")
	elif Vigilante.position.x-100 < position.x && Vigilante.position.x-35 > position.x:
		vel.x = 50
		$Sprite.set_flip_h(false)
		$AnimationPlayer.play("walk")
	else:
		if (Vigilante.position.x+50 > position.x && Vigilante.position.x < position.x+50) || (Vigilante.position.x-50 < position.x && Vigilante.position.x > position.x-50):
			$Sprite.set_flip_h(Vigilante.position.x-position.x<0)
			vel.x = 0
			$AnimationPlayer.play("idle")
		else:
			$Sprite.set_flip_h(direction==-1)
			vel.x = SPEED * direction
			
			$AnimationPlayer.play("walk")
			
			vel.y += grav * delta
			
			vel = move_and_slide(vel, FLOOR)
		
			if is_on_wall():
				direction = direction * -1
				$Sprite.set_flip_h(direction==-1)
	
	vel.y += grav * delta
	vel = move_and_slide(vel, FLOOR)
	
	if vel.y > max_grav:
		vel.y = max_grav

	if is_on_floor() and vel.y > 0:
		vel.y = 0