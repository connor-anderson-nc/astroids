extends CharacterBody2D

@export var laser : PackedScene

const SPEED = 300.0
const ROTATE_SPEED = 3.0
const DECELERATION = 1.0
const ACCELERATION = 5.0
const BOOST = 100.0

func _physics_process(delta: float) -> void:
	# rotation
	if Input.is_action_pressed("left"):
		rotate(deg_to_rad(-ROTATE_SPEED))
	if Input.is_action_pressed("right"):
		rotate(deg_to_rad(ROTATE_SPEED))

	#basic movment
	if Input.is_action_just_pressed("boost"):
		velocity = -self.transform.y * (SPEED + BOOST)

	if Input.is_action_pressed("forward"):
		velocity = velocity.move_toward(-self.transform.y * SPEED, ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, DECELERATION)

	if Input.is_action_pressed("break") && abs(velocity.length()) > 0:
		velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * 3)

	#loop around map
	var deadzone = 20.0
	var relative_pos = self.position - Globals.center

	if abs(relative_pos.x) > Globals.center.x + deadzone:
		self.position.x = -relative_pos.x + Globals.center.x
	if abs(relative_pos.y) > Globals.center.y + deadzone:
		self.position.y = -relative_pos.y + Globals.center.x

	#shooting
	if Input.is_action_just_pressed("shoot"):
		var laser_temp = laser.instantiate()

		laser_temp.linear_velocity = -self.transform.y * 1000
		laser_temp.transform = $laser_start.global_transform
		laser_temp.add_to_group("laser")
		
		add_sibling(laser_temp)
		
		var laser_temp2 = laser_temp.duplicate()
		laser_temp2.transform = $laser_start2.global_transform
		
		add_sibling(laser_temp2)

	#particals
	var trail_mag
	if Input.is_action_pressed("forward"):
		trail_mag = (velocity.length() / 2) + 0.0000001
	else:
		trail_mag = 0

	$trails/trail_left.process_material.set("gravity", self.transform.y * trail_mag)
	$trails/trail_right.process_material.set("gravity", self.transform.y * trail_mag)

	move_and_slide()
