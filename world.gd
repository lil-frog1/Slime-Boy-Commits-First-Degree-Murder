extends Node2D

var enemy
var timer = 0
var shake_timer = 20
var wave = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy = preload("res://enemy.tscn")

func _process(delta):
	timer += 1*delta
	if timer >= (5):
		for _x in range (5 + wave):
			add_child(enemy.instance())
		wave += 1
		timer = 0
	shake_timer += 1
	if shake_timer < 10:
		if position.x < 10:
			position.x += 2
		else:
			position.x -=5
		if position.y < 10:
			position.y += 5
		else:
			position.y -=5
	else:
		position.x = 0
		position.y = 0

func shake():
	shake_timer = 0
func die():
	get_tree().reload_current_scene()
