extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 30
const SPEED = 400
const JUMP_HEIGHT = -750

var life = 4
var is_walking = false
var walking_right = true


var motion = Vector2()



func _physics_process(delta):
	motion.y += GRAVITY 
	
	get_node("CollisionShape2D").disabled = false
	$Sprite.visible = true
	
	if Input.is_action_pressed("ui_right") :
		is_walking = true
		walking_right = true
		motion.x = SPEED;
	elif Input.is_action_pressed("ui_left") :	
		is_walking = true
		walking_right = false
		motion.x = -SPEED
	else :
		is_walking = false
		motion.x = 0
		
	if is_on_floor() :
		if Input.is_action_pressed("ui_up") :
			motion.y = JUMP_HEIGHT

	if Input.is_action_just_pressed("ui_flash") && is_walking: 
		if walking_right :
			$Sprite.visible = false
			get_node("CollisionShape2D").disabled = true
			motion.x = SPEED * 10
		if walking_right == false :
			$Sprite.visible = false
			get_node("CollisionShape2D").disabled = true
			motion.x = -(SPEED * 10)
		
		
		
	motion = move_and_slide(motion, UP)