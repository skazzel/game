extends Area2D

var ammo = 10
var player_pistol
var	label

func _ready():
	label = get_node("/root/game/score/score_text")

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	look_at(get_global_mouse_position())
	if enemies_in_range.size() > 0:
		var target = enemies_in_range[0]
		
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	if ammo != 0:		
		const BULLET = preload("res://bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %shoot.global_position
		new_bullet.global_rotation = %shoot.global_rotation
		%shoot.add_child(new_bullet)
		
		const BULLET2 = preload("res://bullet.tscn")
		var new_bullet2 = BULLET2.instantiate()
		new_bullet2.global_position = %shoot2.global_position
		new_bullet2.global_rotation = %shoot2.global_rotation
		%shoot2.add_child(new_bullet2)
		
		const BULLET3 = preload("res://bullet.tscn")
		var new_bullet3 = BULLET3.instantiate()
		new_bullet3.global_position = %shoot3.global_position
		new_bullet3.global_rotation = %shoot3.global_rotation
		%shoot3.add_child(new_bullet3)
		
		label.text = str(ammo-1) + str("/10")
		ammo -= 1
	else:
		player_pistol = get_node("/root/game/player/pistol")
		self.visible = false
		player_pistol.visible = true
		ammo = 10

func _on_visibility_changed():
	if self.visible == true:
		label.text = str("10/10")
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
