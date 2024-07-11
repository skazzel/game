extends CharacterBody2D

var heath = 100.0
signal heathDepleted

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	
	if velocity.length() > 0.0:
		get_node("HappyBoo").play_walk_animation()
	else:
		get_node("HappyBoo").play_idle_animation()
		
	const DAMAGE = 5.0
	var overlapping_mobs = %hurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		heath -= DAMAGE * overlapping_mobs.size() * delta
		%ProgressBar.value = heath
		if heath <= 0.0:
			heathDepleted.emit()
