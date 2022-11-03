extends Area2D

export var speed = 70
var screen_size
export var timer = 0
export var desired_rotation = Vector2.ZERO
var health = 10
onready var world = get_parent()
onready var health_node = get_node("health")
onready var health_bar = health_node.get_node("healthBar")
var knockback = Vector2.ZERO

#timers for moves
var dash_timer = 0
var frame_timer = 0
var melee_timer = 0
var dash_tween_timer = 3
var immunity_timer = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if health <= 0:
		world.die()

	var velocity = Vector2.ZERO # The player's movement vector.
	
	#timer incrementation
	dash_timer += 1 * delta
	timer += 1 * delta
	melee_timer += 1* delta
	dash_tween_timer += 1
	immunity_timer += 1 * delta
	if dash_timer > 0.05:
		$dashRange/CollisionShape2D.set_deferred('disabled', true)
		$hitbox.set_deferred('disabled', false)
		$hitbox2.set_deferred('disabled', false)
	if melee_timer > 0.05:
		$meleeRange/CollisionShape2D.set_deferred('disabled', true)
	if immunity_timer < 1:
		$hitbox.set_deferred('disabled', true)
		$hitbox2.set_deferred('disabled', true)
#key inputs
	#general movement with player rotation integrated
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		look_at(desired_rotation)
		rotation_degrees += 90
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		look_at(desired_rotation)
		rotation_degrees += 90
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		look_at(desired_rotation)
		rotation_degrees += 90
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		look_at(desired_rotation)
		rotation_degrees += 90

	velocity = velocity.normalized() * speed
	
	if dash_tween_timer <= 3:
		if Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
				velocity = velocity * 100
				$hitbox.set_deferred('disabled', true)
				$hitbox2.set_deferred('disabled', true)
				$dashRange/CollisionShape2D.set_deferred('disabled', false)
				print("enabled")
				dash_timer = 0
	
	#dash
	if Input.is_action_pressed("dash"):
		if dash_timer > 2:
			var dash_cooldown = get_parent().get_node('UI').get_node('timer')
			dash_cooldown.play('default')
			dash_tween_timer = 0
			immunity_timer = 0
	#melee
	if Input.is_action_just_pressed("melee"):
		$meleeRange/CollisionShape2D.set_deferred('disabled', false)
		$AnimatedSprite.stop()
		$AnimatedSprite.play("attack")
		melee_timer = 0
	

	desired_rotation = position + velocity
	
	
	if timer >= 5:
		$AnimatedSprite.play("walk")
		timer = 0


	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, (screen_size.x - 50))
	
	health_node.rotation_degrees = rotation_degrees * -1
	health_bar.frame = health



func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()


func _on_dash_range_area_entered(area):
	if area.is_in_group("hurtbox"):
		print("damaged")
		area.take_damage(3)


func _on_meleeRange_area_entered(area):
	if area.is_in_group("hurtbox"):
		print("damaged")
		area.take_damage(1)


func _on_Player_area_entered(area):
	if area.is_in_group("hitbox"):
		health -= 1
		immunity_timer = 0
		var enemy = area.get_parent()
		knockback = (enemy.position - position) * (-1)
		print(knockback)
		position += knockback
