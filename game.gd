extends Node2D

@onready var timer = $Timer
@onready var in_between_timer = $InBetweenTimer
@onready var remaining_enemies_label = $score/remaining_enemies_label
@onready var wave_count_label = $score/wave_count_label
@onready var player = $player
@onready var player_fast_gun = get_node("/root/game/player/fast_gun")
@onready var player_pistol = get_node("/root/game/player/pistol")
@onready var player_shotgun = get_node("/root/game/player/shotgun")

const BASE_ENEMIES = 10

var start_pos
var current_wave = 1
var max_enemies = 10
var number_of_enemies = 10 
var spawned_enemies = 0

func new_game():
	%gameOver.visible = false
	get_tree().paused = false
	player.heath = 100
	current_wave = 1
	number_of_enemies = 10 
	spawned_enemies = 0
	max_enemies = 10
	set_labels()
	player.position = start_pos
	for mob in %mobs.get_children():
		mob.queue_free()
	for item in %items.get_children():
		item.queue_free()
	player_fast_gun.visible = false
	player_pistol.visible = true
	player_shotgun.visible = false

func _ready():
	in_between_timer.stop()
	GlobalSignals.enemy_killed.connect(on_enemy_killed)
	GlobalSignals.wave_ended.connect(on_wave_ended)
	GlobalSignals.wave_started.connect(on_wave_started)
	start_pos = player.position
	
	set_labels()

func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	%mobs.add_child(new_mob)
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


func _on_game_over_restart():
	new_game()
