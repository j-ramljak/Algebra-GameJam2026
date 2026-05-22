extends Control


@onready var prologue = $"GridContainer/Calendar button8"
@onready var level_1 = $"GridContainer/Calendar button9"
@onready var level_2 = $"GridContainer/Calendar button10"
@onready var level_3 = $"GridContainer/Calendar button11"
@onready var level_4 = $"GridContainer/Calendar button12"


func _ready():
	if Global.last_level_pased == -1:
		level_1.been_pressed = true
		level_2.been_pressed = true
		level_3.been_pressed = true
		level_4.been_pressed = true
	elif Global.last_level_pased == 0:
		prologue.just_finished = true
		level_2.been_pressed = true
		level_3.been_pressed = true
		level_4.been_pressed = true
	elif Global.last_level_pased == 1:
		prologue.finished = true
		
		level_1.just_finished = true
		level_3.been_pressed = true
		level_4.been_pressed = true

	elif Global.last_level_pased == 2:
		prologue.finished = true
		level_1.finished = true
		level_2.just_finished = true
		
		level_4.been_pressed = true
	elif Global.last_level_pased == 3:
		prologue.finished = true
		level_1.finished = true
		level_2.finished = true
		level_3.just_finished = true
		
	prologue.update()
	level_1.update()
	level_2.update()
	level_3.update()
	level_4.update()
