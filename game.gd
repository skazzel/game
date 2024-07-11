extends Node2D

@onready var timer = $Timer
@onready var in_between_timer = $InBetweenTimer
@onready var remaining_enemies_label = $score/remaining_enemies_label
@onready var wave_count_label = $score/wave_count_label

const BASE_ENEMIES = 10

var current_wave = 1
var max_enemies = 10
var number_of_enemies = 10 
var spawned_enemies = 0

func _ready():
	in_between_timer.stop()
	GlobalSignals.enemy_killed.connect(on_enemy_killed)
	GlobalSignals.wave_ended.connect(on_wave_ended)
	GlobalSignals.wave_started.connect(on_wave_started)
	
	set_labels()

func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	spawned_enemies += 1


func _on_timer_timeout():
	if (spawned_enemies < max_enemies):
		spawn_mob()

func _on_in_between_timer_timeout():
	GlobalSignals.wave_started.emit()

func _on_player_heath_depleted():
	%gameOver.visible = true
	get_tree().paused = true
	
func set_labels():
	wave_count_label.text = "Vlna: " + str(current_wave)
	remaining_enemies_label.text = "Zbývá nepřátel: " + str(number_of_enemies)
	
func on_enemy_killed():
	number_of_enemies -= 1
	remaining_enemies_label.text = "Zbývá nepřátel: " + str(number_of_enemies)
	if (number_of_enemies <= 0):
		GlobalSignals.wave_ended.emit()
	
func on_wave_ended():
	timer.stop()
	in_between_timer.start()
	max_enemies = BASE_ENEMIES + current_wave * 5
	number_of_enemies = max_enemies
	spawned_enemies = 0
	current_wave += 1

func on_wave_started():
	set_labels()
	timer.start()
	in_between_timer.stop()
