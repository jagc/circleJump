extends CanvasLayer

func showMessage(text):
	$message.text = text
	$AnimationPlayer.play("showMessage")
	
func hide():
	$scoreBox.hide()
	
func show():
	$scoreBox.show()
	
func updateScore(value):
	$scoreBox/HBoxContainer/score.text = str(value)