extends "res://Objects/fish_class.gd"


func _ready() -> void:
	randomize()
	velocity.x = rand_range(10, 100) * (2*int(position.x < 0)-1)
	scale *= size_factor
	if velocity.x < 0:
		$Sprite.flip_h = true
	$CPUParticles2D.scale *= self.scale.x


func _process(delta: float) -> void:
	if dead:
		if $Sprite.animation != "dead":
			$Sprite.animation = "dead"
		velocity.y = 100
		velocity.x = 0
		$AnimationPlayer.stop()
	else:
		$AnimationPlayer.play("normal")
	position += delta * velocity


func _on_area_entered(area: Area2D) -> void:
	if area.size_factor >= size_factor:
		kill()
		area.size_factor += size_factor * 0.05
		area.scale = area.size_factor * Vector2(1, 1)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

