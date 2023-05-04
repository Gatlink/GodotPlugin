extends Node


var clips : Dictionary
var music : AudioStreamPlayer
var tween : Tween


func _ready() -> void:
	for child in get_children():
		var sound := child as AudioStreamPlayer
		if sound != null:
			clips[sound.name] = sound


func play(clip_name : String) -> void:
	var clip := get_clip(clip_name)
	if clip != null:
		clip.pitch_scale = 1.0
		clip.play()


func play_random_pitch(clip_name : String, min_pitch : float = 0.6, max_pitch : float = 2.0) -> void:
	var clip := get_clip(clip_name)
	if clip != null:
		clip.pitch_scale = randf_range(min_pitch, max_pitch)
		clip.play()


func play_music(clip_name : String) -> void:
	var clip := get_clip(clip_name)
	if music == clip:
		return
	
	if tween != null and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	if music != null:
		tween.tween_property(music, "volume_db", -80, 3)
	
	if clip != null:
		clip.play()
		clip.volume_db = -80
		tween.parallel().tween_property(clip, "volume_db", 0, 3)

	if music != null:
		tween.tween_callback(music.stop)
	
	music = clip


func get_clip(clip_name : String) -> AudioStreamPlayer:
	return clips[clip_name] as AudioStreamPlayer if clips.has(clip_name) else null


func stop(clip_name : String) -> void:
	var clip := get_clip(clip_name)
	if clip != null:
		clip.stop()
