extends Node

var enableSound = true
var enableMusic = true

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