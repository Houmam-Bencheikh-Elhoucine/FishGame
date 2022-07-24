extends "res://Objects/fish_class.gd"


export (int, 10, 1000)var ACC = 10

func _ready():
	scale *= size_factor
	$AnimationPlayer.play("normal")

func _process(delta):
	if not dead:
		var direction = get_input()
		velocity += ACC * direction
		velocity -= 0.1 * velocity

		$AnimationPlayer.playback_speed = 1 + velocity.length_squared() / 50000
		
		if rotation >= PI:
			rotation -= PI
		if velocity.x < 0:
			$Sprite.flip_v = true
		if velocity.x > 0:
			$Sprite.flip_v = false
	else:
		velocity.y = 100

		$AnimationPlayer.stop()
		$Sprite.animation = "dead"

	rotation = velocity.angle()
	position += velocity * delta
	if not dead:
		position = Vector2(
			clamp(position.x, 0, get_viewport_rect().size.x),
			clamp(position.y, 0, get_viewport_rect().size.y-160)
			)

func get_input():
	return Vector2(Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
	 Input.get_action_strength("move_down")-Input.get_action_strength("move_up")).normalized()


func _on_area_entered(area: Area2D) -> void:
	if area.size_factor > size_factor:
		kill()


func kill():
	emit_signal("dead")
	dead = true
	$CollisionShape2D.queue_free()
	$CPUParticles2D.emitting = false
