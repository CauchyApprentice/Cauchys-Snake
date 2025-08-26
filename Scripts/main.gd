extends Node2D

var head_positions: Array[Vector2] = []
var snake_size: int = 1
var snake_parts: Array[CharacterBody2D] = []
var position_scale: int = 10 #how much distance is between the snake parts in terms of head positions index


func add_snake_body():
	var snake_part_scene = preload("res://Scenes/SnakePart.tscn")
	var new_body = snake_part_scene.instantiate()
	snake_size += 1
	new_body.position = head_positions[position_scale * (snake_size - 1)]
	
	snake_parts.push_back(new_body)
	add_child(new_body)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_snake_head_has_moved(new_position: Variant) -> void:
	head_positions.push_front(new_position)
	head_positions.resize(snake_size * position_scale * 10 + 10)
	for part_index: int in range(snake_size-1):
		var body_part = snake_parts[part_index]
		var head_pos_index: int = (part_index + 1) * position_scale
		body_part.position = head_positions[head_pos_index + 1]


func _on_snake_head_food_eaten() -> void:
	for k in range(10):
		add_snake_body()
