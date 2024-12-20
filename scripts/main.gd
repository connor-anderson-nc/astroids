extends Node2D

const center = Vector2(300, 300)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$background/stars/stars1.position.x -= 10 * delta
	$background/stars/stars2.position.x -= 10 * delta
	if $background/stars/stars1.position.x < center.x - 570 * 2:
		$background/stars/stars1.position.x = center.x + 10
	if $background/stars/stars2.position.x < center.x - 570 * 2:
		$background/stars/stars2.position.x = center.x + 10
