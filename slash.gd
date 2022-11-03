extends AnimatedSprite

func _ready():
	var owner = get_parent()
	var hitbox = owner.get_node("hitbox/damageBox")
	hitbox.set_deferred('disabled', true)
	play("slash")


func _on_slash_animation_finished():
	var owner = get_parent()
	owner.die()
	queue_free()
