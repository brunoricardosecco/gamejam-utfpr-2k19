extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 40
const SPEED = 250
const JUMP_HEIGHT = -750
const TELEPORT = 600

var life = 4
var is_walking = false
var walking_right = true
var direction = 1

# Dash
var is_dashing = false
export var dash_speed = 600
var current_speed = SPEED
var dash_cooldown = false


var motion = Vector2()

func _ready() :
	$AnimationPlayer.play("idle")



func _physics_process(delta) :
	motion.y += GRAVITY
	
	get_node("CollisionShape2D").disabled = false
	$Sprite.visible = true
	
	if Input.is_action_pressed("ui_right") :
		is_walking = true
		walking_right = true
		$Sprite.set_flip_h(false)	
		$AnimationPlayer.play("walk")
		direction = 1
		motion.x = current_speed * direction
	elif Input.is_action_pressed("ui_left") :
		$Sprite.set_flip_h(true)
		$AnimationPlayer.play("walk")
		is_walking = true
		walking_right = false
		direction = -1
		motion.x = current_speed * direction
	else :
		$AnimationPlayer.play("idle")
		is_walking = false
		motion.x = 0
		
	if is_on_floor() :
		if Input.is_action_pressed("ui_up") :
			motion.y = JUMP_HEIGHT

	if Input.is_action_just_pressed("ui_flash") && (is_walking or !is_on_floor()): 
		if walking_right :
			$Sprite.visible = false
			get_node("CollisionShape2D").disabled = true
			motion.x = TELEPORT 
		else :
			$Sprite.visible = false
			get_node("CollisionShape2D").disabled = true
			motion.x = -TELEPORT
		
	if Input.is_action_just_pressed("ui_flash"):
		if !dash_cooldown and is_walking:
			$DashTimer.start()
			is_dashing = true
			
	if !is_dashing:
		current_speed = SPEED
	else:
		dash_cooldown = true
		$DashCooldownTimer.start()
		current_speed = dash_speed
		
	motion = move_and_slide(motion, UP)