extends Area2D

class_name fish

signal dead

var velocity: = Vector2.ZERO
var size_factor = 1.0
var dead = false

func kill():
	collision_layer = 0
	collision_mask = 0
	emit_signal("dead")
	dead = true
