//
//  Sounds.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/30/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit
import AVFoundation


// Global sound
// Audio nodes for sound effects and music
var audioPlayer = AVAudioPlayer()
var player = AVAudioEngine()
var audioFile = AVAudioFile()
var audioPlayerNode = AVAudioPlayerNode()
var bgMusic = SKAudioNode(fileNamed: "bgMusic")
var startGameSound = SKAudioNode(fileNamed: "startGame")
var biplaneFlyingSound = SKAudioNode(fileNamed: "biplaneFlying")
var gunfireSound = SKAudioNode(fileNamed: "gunfire")
var coinSound = SKAudioNode(fileNamed: "coin")
var powerUpSound = SKAudioNode(fileNamed: "powerUp")
var skyBoomSound = SKAudioNode(fileNamed: "skyBoom")
var crashSound = SKAudioNode(fileNamed: "crash")
var propSound = SKAudioNode(fileNamed: "prop")
var planesFightSound = SKAudioNode(fileNamed: "planesFight")
var bGCannonsSound = SKAudioNode(fileNamed: "bGCannons")
var planeMGunSound = SKAudioNode(fileNamed: "planeMachineGun")
var mortarSound = SKAudioNode(fileNamed: "mortar")
var airplaneFlyBySound = SKAudioNode(fileNamed: "airplaneFlyBy")
var airplaneP51Sound = SKAudioNode(fileNamed: "airplanep51")
var mp5GunSound = SKAudioNode(fileNamed: "mp5Gun")
var shootSound = SKAudioNode(fileNamed: "shoot")


class Sounds: SKAudioNode {
    
    
    /********************************* Preloading Sound & Music *********************************/
    // MARK: - Spawning
    
    // After import AVFoundation, needs do,catch statement to preload sound so no delay
    func setUpEngine() {
        do {
            let sounds = ["coin", "startGame", "bgMusic", "biplaneFlying", "gunfire", "mortar", "crash", "powerUp", "skyBoom", "planesFight", "planeMachineGun", "bGCannons", "tank", "prop", "airplaneFlyBy", "airplanep51", "mp5Gun", "shoot"]
            
            for sound in sounds {
                
                let player = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(sound, ofType: "mp3")!))
                
                player.prepareToPlay()
                
            }
        } catch {
            print("AVAudio has had an \(error).")
        }
    }
}
