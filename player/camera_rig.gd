extends Node3D

@onready var background_viewport = $BaseCamera/BackgroundViewportContainer/BackgroundViewport
@onready var foreground_viewport = $BaseCamera/ForegroundViewportContainer/ForegroundViewport

@onready var background_camera = $BaseCamera/BackgroundViewportContainer/BackgroundViewport/BackgroundCamera
@onready var foreground_camera = $BaseCamera/ForegroundViewportContainer/ForegroundViewport/ForegroundCamera


## Ignore o codigo abaixo, ele provavelmente é inútil

# Called when the node enters the scene tree for the first time.
#func _ready():
#	resize()

#func resize():
#	background_viewport.size = DisplayServer.window_get_size()
#	foreground_viewport.size = DisplayServer.window_get_size()

## Fim da parte inútil, ela ta ai só pro caso de acontecer alguma coisa

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	background_camera.global_transform = GameManager.player.camera_point.global_transform
	foreground_camera.global_transform = GameManager.player.camera_point.global_transform
