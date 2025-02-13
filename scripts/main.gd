extends Node2D

@export var astroid: PackedScene

const background_speed = 10
@onready var spawn_timer = $astrioid_spawn/spawn_timer
var spawn_wait_times = [1, 3]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	spawn_astroid()
	
	spawn_wait_times = [
		clamp(min(spawn_wait_times[0] / (Globals.score * 0.5), spawn_wait_times[0]), 1, 10),
		clamp(min(spawn_wait_times[1] / (Globals.score * 0.5), spawn_wait_times[1]), 1, 10)
	]
	
	spawn_timer.wait_time = randf_range(spawn_wait_times[0], spawn_wait_times[1])
	
	spawn_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_background($world/stars/stars1, background_speed, 450, 300)
	move_background($world/stars/stars2, background_speed, 450, 300)
	move_background($world/nebulas/nebula, background_speed/2, 475, 300)
	move_background($world/nebulas/nebula2, background_speed/2, 475, 300)

func move_background(sprite, speed, r, rt):
	sprite.position.x -= speed * get_process_delta_time()
	if sprite.position.x < Globals.center.x - r * 2:
		sprite.position.x = Globals.center.x + rt

func spawn_astroid():
	var pos = $astrioid_spawn/spawn_path/pos
	pos.progress_ratio = randf()

	var direction = (pos.rotation + PI / 2) + randf_range(-PI / 4, PI / 4)
	
	var speed = randf_range(100, 250)
	var velocity = (Vector2.ONE * speed).rotated(direction)
	
	var spin = randf_range(-15, 15)
	
	var temp_astroid = astroid.instantiate()
	temp_astroid.position = pos.position
	temp_astroid.rotation = direction
	temp_astroid.linear_velocity = velocity
	temp_astroid.angular_velocity = spin
	add_child(temp_astroid)
