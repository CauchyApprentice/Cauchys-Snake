extends CharacterBody2D

var speed: float = 4
var init_vel = Vector2.RIGHT * speed #vel == velocity
var ang_speed: float = deg_to_rad(270) #turning speed
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
		var collider = collision.get_collider()
		
		if collider.is_in_group("foods"):
			collider.queue_free() #removes food
			food_eaten.emit()
		elif collider.is_in_group("walls"):
			var normal_vec: Vector2 = collision.get_normal() #the minus is there so that the vector points the same way as the velocity vector
			var normal_transform: Transform2D = Transform2D()
			normal_transform.x = normal_vec
			print("Velocity Vector Init: "+"("+str(round(velocity.x))+", "+str(round(velocity.y))+")")
			print("Normal Vector: "+"("+str(round(normal_vec.x))+", "+str(round(normal_vec.y))+")")
			normal_transform.y = normal_vec.orthogonal()
			var velocity_in_normal: Vector2 = normal_transform.basis_xform(velocity)
			print("Velocity_in_Normal Vector: "+"("+str(round(velocity_in_normal.x))+", "+str(round(velocity_in_normal.y))+")")
			velocity_in_normal.y = 0
			
			velocity = normal_transform.basis_xform_inv(velocity_in_normal)
			print("Velocity Vector Back: "+"("+str(round(velocity.x))+", "+str(round(velocity.y))+")")
			velocity = speed * velocity.normalized()
			print(velocity.dot(normal_vec))
		
