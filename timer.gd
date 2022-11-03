extends AnimatedSprite

func _ready():
	frame = 0


func _on_timer_animation_finished():
	stop()
