extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

# Все треки
const TRACKS = {
	"menu": preload("res://Audio/music/main_music.ogg"),
	"room1": preload("res://Audio/music/scene1.ogg"),
}

# Громкость по умолчанию
var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0

# Текущий трек
var current_track: String = ""

func _ready():
	# Применяем текущую громкость к AudioServer при старте
	_update_volumes()
	


# ----------------------------
# Воспроизведение трека
func play(name: String):
	if not TRACKS.has(name):
		push_warning("Нет музыки с именем: " + name)
		return

	if current_track != name:
		current_track = name
		player.stream = TRACKS[name]
		player.play()


# ----------------------------
# Функции изменения громкости
func set_master_volume(value: float):
	master_volume = value
	_update_volumes()

func set_music_volume(value: float):
	music_volume = value
	_update_volumes()

func set_sfx_volume(value: float):
	sfx_volume = value
	_update_volumes()


# ----------------------------
# Применение громкости к Audio Bus
func _update_volumes():
	# Master
	if master_volume <= 0.01:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))

	# Music
	if music_volume <= 0.01:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))

	# SFX
	if sfx_volume <= 0.01:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))
