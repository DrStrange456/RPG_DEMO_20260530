extends Control

@onready var music_sample: AudioStreamPlayer2D = $Panel/Sounds/Music_Sample
@onready var sfx_sample: AudioStreamPlayer2D = $Panel/Sounds/SFX_Sample



enum State {DEFAULT,INVENTORY,SETTINGS,VIDEO,AUDIO,CHARACTER}
var ps_state 





### - Sound Options

func _on_sfx_volume_value_changed(value: float) -> void:
	$Panel/SFX/sfx_volume/txtValue_SFX.text = str(value)
	apply_audio_sfx_settings()

func _on_music_volume_value_changed(value: float) -> void:
	$Panel/MUSIC/music_volume/txtValue_Music.text = str(value)
	apply_audio_music_settings()

func apply_audio_sfx_settings():
	if ps_state != State.AUDIO: return
	if music_sample.playing: music_sample.stop()
	
	if !sfx_sample.playing:
		sfx_sample.play()
	sfx_sample.volume_db = (40 * (float($Panel/SFX/sfx_volume/txtValue_SFX.text) / 100)) - 20

func apply_audio_music_settings():
	if ps_state != State.AUDIO: return
	if sfx_sample.playing: sfx_sample.stop()
	
	if !music_sample.playing:
		music_sample.play()
	music_sample.volume_db = (40 * (float($Panel/MUSIC/music_volume/txtValue_Music.text) / 100)) - 20
