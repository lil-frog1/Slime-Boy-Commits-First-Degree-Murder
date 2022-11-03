extends Area2D


var health = 3
var knockback = 0
var startx = 0
var target = Vector2.ZERO
var knockback_timer = 1


# Called when the node enters the scene tree for the first time.
var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()
	startx = rng.randi_range(0, 1)
	if startx == 0:
		position.x = 0
	else:
		position.x = 400
	rng.randomize()
	position.y = rng.randf_range(0, 400)

func _process(delta):
	knockback_timer += delta
	var player = get_parent().get_node("Player")
	target = player.position - position
	target = target.normalized() / 4
	if knockback_timer > 1:
		position += target
		$hitbox/damageBox.disabled = false

func take_damage(ammount):
	var slash = preload("res://slash.tscn")
	var player = get_parent().get_node("Player")
	var world = get_parent()
	world.shake()
	health -= ammount
	print(health)
	knockback = (player.position - position) * (-1)
	if knockback.x > 0:
		knockback.x = 30
	else:
		knockback.x = -30
	if knockback.y > 0:
		knockback.y = 30
	else:
		knockback.y = -30
	print(knockback)
	position += knockback
	add_child(slash.instance())
	knockback_timer = 0
		
func die():
	if health <= 0:
		queue_free()
