extends Label

var score: int = 0

func _process(delta: float) -> void:
	text = "You lost!\nScore: " + str(score)
