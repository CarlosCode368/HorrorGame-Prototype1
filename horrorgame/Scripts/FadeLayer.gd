extends CanvasLayer

@onready var fade_rect = $fadeRect

func _ready():
	fade_rect.modulate.a = 0.0  # Start fully transparent

func fade_out(duration: float = 1.0, callback: Callable = Callable()):
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, duration)
	await tween.finished
	if callback.is_valid():
		callback.call()

func fade_in(duration: float = 1.0):
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, duration)
	await tween.finished
