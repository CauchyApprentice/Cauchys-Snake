extends Node2D

var head_positions: Array[Vector2] = []
var snake_size: int = 1
var snake_parts: Array[CharacterBody2D] = []
var index_scale: int = 3 #how much distance is between the snake parts in terms of head positions index
var nourish: int = 3 #how many body parts are added when eating



func add_snake_body() -> void:
	var snake_part_scene = preload("res://Scenes/SnakePart.tscn")
	var new_body = snake_part_scene.instantiate()
	snake_size += 1
	new_body.position = head_positions[index_scale * (snake_size - 1)]
	
	snake_parts.push_back(new_body)
	add_child(new_body)


func spawn_food() -> void:
	var food_pos: Vector2 = new_food_pos()
	var food_scene = preload("res://Scenes/food.tscn")
	var food = food_scene.instantiate()
	food.position = food_pos
	add_child(food)


func new_food_pos() -> Vector2:
	var game_size: Vector2 = ($background.mesh as QuadMesh).size
	var new_pos = func(): return Vector2(randf_range(-1, 1) * game_size.x/2, randf_range(-1, 1) * game_size.y/2)
	var food_pos: Vector2 = Vector2(0,0)#new_pos.call()
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	var intersect = space_state.intersect_point(query, 1)
	var limit: int = 100
	
	while intersect:
		limit -= 1
		food_pos = new_pos.call()
		query.position = food_pos
		intersect = space_state.intersect_point(query, 1)
		
		if limit == 0:
			push_error("Found no valid food position.")
	
	return food_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_food()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_snake_head_has_moved(new_position: Variant) -> void:
	head_positions.push_front(new_position)
	head_positions.resize(snake_size * index_scale * nourish + 10)
	for part_index: int in range(snake_size-1):
		var body_part = snake_parts[part_index]
		var head_pos_index: int = (part_index + 1) * index_scale
		body_part.position = head_positions[head_pos_index + 1]


func _on_snake_head_food_eaten() -> void:
	spawn_food()
	for k in range(nourish):
		add_snake_body()
