extends RichTextLabel

onready var Timer = get_parent().get_node("Timer")

var dialog = ["Olá, filho da puta! Ta achando que isso aqui é a casa da mãe joana?, seu arrombado!!\nVai tomar no cu e mete a porra do pé, cuzão do caralho!", "Ta tirando com a minha cara sua puta, fala mais que te meto bala!"]
var page = -1

func _setPage(new_page):
	page=new_page
	set_bbcode(dialog[page])

func _ready():
	set_visible_characters(0)
	set_process_input(true)

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if get_visible_characters() > get_total_character_count():
			if page < dialog.size()-1:
				page += 1
				set_bbcode(dialog[page])
				set_visible_characters(0)

func _on_Timer_timeout():
	if(page>=0):
		set_visible_characters(visible_characters+1)
	else:
		page=-1
