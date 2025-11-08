extends Control
class_name PlayerUiComponent

@onready var ui_crosshair = $UICrosshair


func hide_crosshair():
	ui_crosshair.visible = false

func unhide_crosshair():
	ui_crosshair.visible = true
