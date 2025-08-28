extends Label

var score: int = 5

func _process(_delta: float) -> void:
	text = "You lost!\nScore: " + str(score)
