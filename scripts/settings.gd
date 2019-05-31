extends Node

const SAVE_FILE_PATH = "user://circleJumpData.save"

var enableSound = true
var enableMusic = true
var data

var circlesPerLevel = 5

var color_schemes = {
    "NEON1": {
        'background': Color8(0, 0, 0),
        'player_body': Color8(203, 255, 0),
        'player_trail': Color8(204, 0, 255),
        'circle_fill': Color8(255, 0, 110),
        'circle_static': Color8(0, 255, 102),
        'circle_limited': Color8(204, 0, 255)
    },
    "NEON2": {
        'background': Color8(0, 0, 0),
        'player_body': Color8(246, 255, 0),
        'player_trail': Color8(255, 255, 255),
        'circle_fill': Color8(255, 0, 110),
        'circle_static': Color8(151, 255, 48),
        'circle_limited': Color8(127, 0, 255)
    },
    "NEON3": {
        'background': Color8(0, 0, 0),
        'player_body': Color8(255, 0, 187),
        'player_trail': Color8(255, 148, 0),
        'circle_fill': Color8(255, 148, 0),
        'circle_static': Color8(170, 255, 0),
        'circle_limited': Color8(204, 0, 255)
    }
}

var theme = color_schemes["NEON2"]

func _ready():
	data = loadData()
	enableMusic = data["enableMusic"]
	enableSound = data["enableSound"]

func saveData(score = null):
	if score != null:
		if loadHighScore() > score:
			return
	
	var _file = File.new()
	_file.open(SAVE_FILE_PATH, File.WRITE)
	
	var _data = {
		highScore = score,
		enableSound = enableSound,
		enableMusic = enableMusic
	}
	
	_file.store_line(to_json(_data))
	_file.close()

func loadData():
	var _file = File.new()
	if !_file.file_exists(SAVE_FILE_PATH):
		return 0
		
	_file.open(SAVE_FILE_PATH, File.READ)
	var _data = parse_json(_file.get_line())
	
	return _data
	
func loadHighScore():
	var highScore = 0 if data["highScore"] == null else data["highScore"]
	return highScore