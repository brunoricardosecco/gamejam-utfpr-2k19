extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 40
const SPEED = 250
const JUMP_HEIGHT = -750
const TELEPORT = 600
const MAXHEALTH = 4

var is_walking = false
var walking_right = true
var direction = 1
var health = MAXHEALTH

# Dash
var is_dashing = false
export var dash_speed = 4000
var current_speed = SPEED
var dash_cooldown = false

# fireball scene

export (PackedScene) var fireball_scene

#smoke scene
export (PackedScene) var teleport_smoke_scene

export (float) var fireball_delay = 0.2
var waited = 0

#fireball spawn

export (NodePath) var fireball_spawn_right_path
onready var fireball_spawn_right = get_node(fireball_spawn_right_path)

export (NodePath) var fireball_spawn_left_path
onready var fireball_spawn_left = get_node(fireball_spawn_left_path)

#telepor smoke spawn
export (NodePath) var teleport_smoke_path
onready var teleport_spawn = get_node(teleport_smoke_path)

#fireball gravity
export (int) var fireball_gravity = 5

#direcitonal force for our fireball
var directional_force = Vector2()

#shooting
var shooting = false

#fireball speed
export (int) var fireball_speed = 10

#fireball angle
export (float) var fireball_angle = 360 setget set_fireball_angle

func set_fireball_angle(value):
	fireball_angle = clamp(value, 0, 360)
	
func update_directional_force():
	if (direction == 1) :
		directional_force = Vector2(1,0) * fireball_speed
	elif (direction == -1) :
		directional_force = Vector2(1,0) * -fireball_speed

var motion = Vector2()

func _ready() :
	$Sprite.set_flip_h(true)
	$AnimationPlayer.play("vigilant_idle")
	


func _input(event):
	if(event.is_action_pressed("ui_select")):
		shooting = true
	elif(event.is_action_released("ui_select")):
		shooting = false

func _process(delta):
	if(shooting && waited > fireball_delay):
		fire_once()
		waited = 0
	elif (waited <= fireball_delay):
		waited += delta
	
func fire_once():
	shoot()
	shooting = false

func _physics_process(delta) :
	motion.y += GRAVITY
	
	update_directional_force()
	
	get_node("CollisionShape2D").disabled = false
	$Sprite.visible = true
	
	if Input.is_action_pressed("ui_right") :
		is_walking = true
		walking_right = true
		$Sprite.set_flip_h(true)
		if (Input.is_action_pressed("ui_select") && shooting == false):
			$AnimationPlayer.play("vigilant_walk_shoot")
		else:
			$AnimationPlayer.play("vigilant_walk")
		direction = 1
		motion.x = current_speed * direction
	elif Input.is_action_pressed("ui_left") :
		$Sprite.set_flip_h(false)
		if (Input.is_action_pressed("ui_select") && shooting == false):
			$AnimationPlayer.play("vigilant_walk_shoot")
		else:
			$AnimationPlayer.play("vigilant_walk")
		is_walking = true
		walking_right = false
		direction = -1
		motion.x = current_speed * direction
	else :
		if(is_walking == false && Input.is_action_pressed("ui_select") && shooting == false):
			$AnimationPlayer.play("vigilant_idle_shoot")
			is_walking = false
			motion.x = 0
		else:
			$AnimationPlayer.play("vigilant_idle")
			is_walking = false
			motion.x = 0
		
	if is_on_floor() :
		if Input.is_action_pressed("ui_up") :
			motion.y = JUMP_HEIGHT

	if Input.is_action_just_pressed("ui_flash"):
		if !dash_cooldown and is_walking:
			$DashTimer.start()
			is_dashing = true
			smoke()
			
	if !is_dashing:
		current_speed = SPEED
	else:
		dash_cooldown = true
		$DashCooldownTimer.start()
		current_speed = dash_speed
		$Sprite.visible = false
		motion.y = 0
		set_collision_layer_bit(2, false);
		
	motion = move_and_slide(motion, UP)
	
func _on_DashTimer_timeout():
	is_dashing = false
	set_collision_layer_bit(1, true);
	
	
func _on_DashCooldownTimer_timeout():
	dash_cooldown = false
	
func shoot():
	var fireball = fireball_scene.instance()
	if (direction == 1):
		fireball.set_global_position(get_node("fireball_right_spawn").get_global_position())
	elif (direction == -1):
		fireball.set_global_position(get_node("fireball_left_spawn").get_global_position())
	fireball.shoot(directional_force, fireball_gravity, direction)
	get_parent().add_child(fireball)
	
func smoke():
	var teleport_smoke = teleport_smoke_scene.instance()
	teleport_smoke.set_global_position(get_node("teleport_smoke_spawn").get_global_position())
	teleport_smoke.appear()
	get_parent().add_child(teleport_smoke)
	
