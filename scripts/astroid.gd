extends RigidBody2D

var ASTROIDS: PackedScene = load("res://astroid.tscn")

const sprites = "res://assets/textures/astroids"

# child spawning constants
const child_spawn_radius = 20
const velocity_dampener = 1.5

var texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_choose_texture($Sprite2D)
	#_create_collision_polygon($Sprite2D) # commented out for now add back later hopefully
	$Collider.set_deferred("polygon", $temp_polygon_holder.polygon)
	$Area2D/Collider2.set_deferred("polygon", $temp_polygon_holder.polygon)
	
	if self.has_meta("scale"):
		$Sprite2D.scale = self.get_meta("scale")
		$Area2D/Collider2.scale = self.get_meta("scale") * 1.3
		$Collider.scale = self.get_meta("scale")
		print(self.get_meta("scale"))
	else:
		var scale = randf_range(1.5, 2.4)
		$Sprite2D.scale = Vector2.ONE * scale
		$Area2D/Collider2.scale = Vector2.ONE * scale * 1.05
		$Collider.scale = Vector2.ONE * scale
		print(scale)

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if not body.is_in_group("laser"):
		return
	
	Globals.score += 1
	body.queue_free()
	
	if self.scale.x < 1:
		queue_free()
		return
	
	var child1 = ASTROIDS.instantiate()
	var child2 = ASTROIDS.instantiate()
	
	var velocity_angle = randf_range(20, 60)
	child1.linear_velocity = self.linear_velocity.rotated(velocity_angle)
	child1.linear_velocity = self.linear_velocity.rotated(-velocity_angle)
	
	# position
	var angle = randf() * TAU
	var distance = randf() * child_spawn_radius
	var offset = Vector2(cos(angle), sin(angle)) * distance
	var offset2 = Vector2(cos(-angle), sin(-angle)) * distance
	
	child1.position = self.global_position + offset
	child2.position = self.global_position + offset2
	
	child1.set_meta("scale", self.scale / 1.5)
	child2.set_meta("scale", self.scale / 1.5)
	
	self.visible = false
	self.call_deferred("add_sibling", child1)
	self.call_deferred("add_sibling", child2)
	
	queue_free()

######### setup functions ###########
func _create_collision_polygon(sprite): # broken
	var bm = BitMap.new()
	bm.create_from_image_alpha(sprite.texture.get_image().get_data())
	var rect = Rect2(0, 0, sprite.texture.get_width(), sprite.texture.get_height())
	var my_array = bm.opaque_to_polygons(rect)
	var my_polygon = Polygon2D.new()
	my_polygon.set_polygons(my_array)
	get_parent().get_node("Collider").set_polygon(my_polygon.polygon)

func _choose_texture(sprite):
	var dir := DirAccess.open(sprites)
	var file_names := dir.get_files()

	var resources: Array[Resource] = []
	for file_name in file_names:
		if file_name.get_extension() == "png":
			resources.append(load(sprites + "/" + file_name))

	sprite.texture = resources.pick_random()
