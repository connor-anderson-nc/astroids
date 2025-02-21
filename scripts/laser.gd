extends RigidBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(3.0).timeout
	queue_free()



func _on_body_entered(body: Node) -> void:
	body.queue_free()
	queue_free()
