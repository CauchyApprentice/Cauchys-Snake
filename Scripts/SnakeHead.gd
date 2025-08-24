extends CharacterBody2D

var speed: float = 10
var init_vel = Vector2(1, 0) * speed #vel == velocity



func get_relative_mouse_position(): #mouse position relative to node coordinate system
	var viewportSystem = get_viewport().get_mouse_position() #mouse position from viewport perspective
	var transformVector = get_viewport_rect().size / 2 #vector from viewport origin to nodes' origin
	return viewportSystem - transformVector #resulting relative mouse position


func _ready() -> void:
	velocity = init_vel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
