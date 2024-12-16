return {
    -- scenes/
    sceneManager = require("scenes/sceneManager"),
    sceneMenu = require("scenes/sceneMenu"),
    scenePause = require("scenes/scenePause"),
    sceneGame = require("scenes/sceneGame"),
    sceneSettings = require("scenes/sceneSettings"),
    scenedefeat = require("scenes/scenedefeat"),
    sceneMarket = require("scenes/sceneMarket"),
    --scripts/
    player = require("scripts/player"),
    enemy = require("scripts/enemy"),
    nexus = require("scripts/nexus"),
    wallet = require("scripts/wallet"),
    gameUI = require("scripts/gameUI"),
    --libs
    button = require("libs/button"),
    audioManager = require("libs/audioManager"),
    keybindings = require("libs/keybindings"),
    json = require("libs/json"),
    utils = require("libs/utils")
}
