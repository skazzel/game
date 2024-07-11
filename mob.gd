extends CharacterBody2D

var player
var scene
var mob
var health = 3

func _ready():
	scene = get_node("/root/game")
	player = get_node("/root/game/player")
	mob = get_node("/root/game/mob")
	%Slime.play_walk()

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 300
	move_and_slide()

func drop_item():
	var item = preload("res://item.tscn").instantiate()
	item.position = position
	item.item_type = randi_range(0, 1)
	scene.add_child(item)
	item.add_to_group("items")

func take_damage():
	health -= 1
	%Slime.play_hurt()
	
	if health == 0:
		var random_number = randf()
		if snapped(random_number, 0.1) == 1:
			drop_item()
		queue_free()
		GlobalSignals.enemy_killed.emit()
