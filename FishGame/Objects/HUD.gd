extends Control


func update():
	$score.text = "score : "+str(get_parent().score)
