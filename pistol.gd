extends Area2D

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	look_at(get_global_mouse_position())
	if enemies_in_range.size() > 0:
		var target = enemies_in_range[0]
		
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %shoot.global_position
	new_bullet.global_rotation = %shoot.global_rotation
	%shoot.add_child(new_bullet)


func _on_visibility_changed():
	var	label = get_node("/root/game/score/score_text")
	label.text = str("∞/∞")
	
