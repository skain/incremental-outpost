extends Node
class_name SfxManagerAutoload

func play_sfx(stream: AudioStream, position: Vector2 = Vector2.ZERO) -> void:
	if not stream: return
	
	var player := AudioStreamPlayer2D.new()
	player.stream = stream
	player.position = position
	
	# Randomize pitch slightly so it doesn't get "machine-gun" fatigue
	player.pitch_scale = randf_range(0.9, 1.1)
	
	add_child(player)
	player.play()
	
	# This is the magic part: it deletes itself only when finished
	player.finished.connect(player.queue_free)
