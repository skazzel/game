extends Area2D

var item_type : int
var player_pistol
var player_shotgun
var player_fast_gun
var shotgun = preload("res://shotgun/wYVuao.png")
var fast_gun = preload("res://fast_gun/wLTza5.png")
var textures = [shotgun, fast_gun]

func _ready():
	player_fast_gun = get_node("/root/game/player/fast_gun")
	player_pistol = get_node("/root/game/player/pistol")
	player_shotgun = get_node("/root/game/player/shotgun")
	$Sprite2D.texture = textures[item_type]

func _on_body_entered(body):
	if item_type == 0:
		player_fast_gun.visible = false
		player_pistol.visible = false
		player_shotgun.visible = true
	elif item_type == 1:
		player_fast_gun.visible = true
		player_pistol.visible = false
		player_shotgun.visible = false
	
	queue_free()
