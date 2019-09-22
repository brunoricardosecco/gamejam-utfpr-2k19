extends KinematicBody2D

onready var Vigilante = get_parent().get_node("Vigilante")
onready var Dialog = get_parent().get_node("Dialog")
onready var DialogPage = get_parent().get_node("Dialog/RichTextLabel")

const SPEED = 50
const FLOOR = Vector2(0,-1)

var vel = Vector2(0,0)
#var velocity = Vector2()

var direction = 1

var grav = 1000
var max_grav = 3000

func _ready() :
	$AnimationPlayer.play("idle")

func _physics_process(delta):
	if (Vigilante.position.x+50 > position.x && Vigilante.position.x < position.x+50) || (Vigilante.position.x-50 < position.x && Vigilante.position.x > position.x-50):
		$Sprite.set_flip_h(Vigilante.position.x-position.x<0)
		vel.x = 0
		$AnimationPlayer.play("idle")
		Dialog.visible = true
		if(DialogPage.page < 0):
			DialogPage._setPage(0)
	else:
		Dialog.visible = false

	vel.y += grav * delta
	vel = move_and_slide(vel, FLOOR)
	
	if is_on_floor() and vel.y > 0:
		vel.y = 0