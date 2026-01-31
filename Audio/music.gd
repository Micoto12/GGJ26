# music.gd
extends Node

# --- ПЛЕЕРЫ ---
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

# --- ТРЕКИ ---
const TRACKS = {
	"menu": preload("res://Audio/music/main_music.ogg"),
	"room1": preload("res://Audio/music/scene1.ogg"),
}

const SFX_TRACKS = {
	"click": preload("res://audio/sfx/click.ogg"),
	"hover": preload("res://audio/sfx/hover.ogg"),
}

# --- ГРОМКОСТЬ ---
var master_volume := 1.0
var music_volume := 1.0
var sfx_volume := 1.0

var current_track := ""

func _ready():
	# 🎵 Music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)

	# 🔊 SFX player
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX"
	add_child(sfx_player)

	_update_volumes()

# ----------------------------
# МУЗЫКА
func play(name: String):
	if not TRACKS.has(name):
		push_warning("Нет музыки: " + name)
		return

	if current_track != name:
		current_track = name
		music_player.stream = TRACKS[name]
		music_player.play()

# ----------------------------
# SFX
func play_sfx(name: String):
	if not SFX_TRACKS.has(name):
		push_warning("Нет SFX: " + name)
		return

	sfx_player.stream = SFX_TRACKS[name]
	sfx_player.play()

# ----------------------------
# ГРОМКОСТЬ
func set_master_volume(v: float):
	master_volume = v
	_update_volumes()

func set_music_volume(v: float):
	music_volume = v
	_update_volumes()

func set_sfx_volume(v: float):
	sfx_volume = v
	_update_volumes()

func _update_volumes():
	_set_bus("Master", master_volume)
	_set_bus("Music", music_volume)
	_set_bus("SFX", sfx_volume)

func _set_bus(bus: String, value: float):
	var idx = AudioServer.get_bus_index(bus)
	if value <= 0.01:
		AudioServer.set_bus_volume_db(idx, -80)
	else:
		AudioServer.set_bus_volume_db(idx, linear_to_db(value))
