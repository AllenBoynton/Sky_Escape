//
//  MainMenu.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/20/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit
import AVFoundation


class MainMenu: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        var bgMusic = SKAction.playSoundFileNamed("bgMusic", waitForCompletion: false)
        
        func playSound(soundVariable: SKAction) {
            runAction(soundVariable)
        }
        
        playSound(bgMusic)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let game: InstructionScene = InstructionScene(fileNamed: "InstructionScene")!
        game.scaleMode = .AspectFit
        bgMusic.runAction(SKAction.stop())
        let transition: SKTransition = SKTransition.doorsOpenHorizontalWithDuration(3.0)
        self.view?.presentScene(game, transition: transition)
    }
}
