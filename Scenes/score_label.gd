extends Label

var score: int = 0

func _process(_delta: float) -> void:
	text = "Score: " + str(score)
