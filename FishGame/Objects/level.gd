extends Node2D


var min_val = 0.5
var max_val = 1.5

var score = 0

var enemy_spawns = []
var enemy_fish = [preload("fish01.tscn"), preload("fish02.tscn"), preload("fish03.tscn")]
var fish = preload("player_fish.tscn")

onready var start = true
var fish_dead = false

func _ready()->void:
	enemy_spawns = [$enemy_spawn01/enemy_follow1, $enemy_spawn02/enemy_follow2]
	randomize()
	$HUD.visible = false
func _process(delta):
	if Input.is_action_just_pressed("start"):
		if start:
			var f = fish.instance()
			f.position.x = 512
			f.position.y = 300
			f.connect("dead", self, "_on_fish01_dead")
			$Node2D.add_child(f)
			fish_dead = false
			start = false
			$HUD.visible = true
			$Timer.start()
		if fish_dead:
			get_tree().reload_current_scene()
	$Start.visible = start
	$YouDied.visible = fish_dead

func _on_Timer_timeout() -> void:
	var x = randi()%2
	var path = enemy_spawns[x]
	path.set_unit_offset(rand_range(0, 1))
	var pos = path.position
	var e = enemy_fish[randi()%3].instance()
	e.position = pos
	e.size_factor = int(10*rand_range(min_val, max_val))/10.0
	e.connect("dead", self, "_on_enemy_dead")
	$Node2D.add_child(e)

func _on_enemy_dead():
	score += 1
	max_val += 0.05
	min_val += 0.05
	$Timer.wait_time *= 0.99
	$HUD.update()


func _on_fish01_dead() -> void:
	fish_dead = true
	$YouDied/score.text += str(score)
