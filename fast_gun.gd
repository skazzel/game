extends Area2D

var ammo = 40
var player_pistol
var	label

func _ready():
	label = get_node("/root/game/score/score_text")
	
func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	look_at(get_global_mouse_position())
	if enemies_in_range.size() > 0:
		var target = enemies_in_range[0]
		
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot():
	if ammo != 0:
		const BULLET = preload("res://bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %shoot.global_position
		new_bullet.global_rotation = %shoot.global_rotation
		%shoot.add_child(new_bullet)
		
		label.text = str(ammo-1) + str("/40")
		ammo -= 1
	else:
		player_pistol = get_node("/root/game/player/pistol")
		self.visible = false
		player_pistol.visible = true
		ammo = 40

func _on_visibility_changed():
	if self.visible == true:
		print("visible")
		label.text = str("40/40")
		print(label.text)
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		print("NOT")
		process_mode = Node.PROCESS_MODE_DISABLED
