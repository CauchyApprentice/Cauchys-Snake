extends CharacterBody2D

var speed: float = 3
var init_vel = Vector2.RIGHT * speed #vel == velocity
var ang_speed: float = deg_to_rad(135) #turning speed
signal food_eaten
signal has_moved(new_position)




func adjust_direction(_delta) -> void:
	var mouse_position = get_relative_mouse_position()
	var rel_mouse_position = mouse_position - position
	var angle_to_mouse = velocity.angle_to(rel_mouse_position)
		
	if angle_to_mouse != 0:
		velocity = velocity.rotated(sign(angle_to_mouse) * ang_speed * _delta)
		

func get_relative_mouse_position(): #mouse position relative to node coordinate system
	var viewportSystem = get_viewport().get_mouse_position() #mouse position from viewport perspective
	var transformVector = get_viewport_rect().size / 2 #vector from viewport origin to nodes' origin
	return viewportSystem - transformVector #resulting relative mouse position


func _ready() -> void:
	velocity = init_vel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	adjust_direction(delta)
	has_moved.emit(position)
	
	var collision = move_and_collide(velocity)
	if collision: #food was found
		collision.get_collider().queue_free() #removes food
		food_eaten.emit()

		
