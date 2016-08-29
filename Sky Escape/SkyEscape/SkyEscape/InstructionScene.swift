//
//  InstructionScene.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/23/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit
import AVFoundation


class InstructionScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        bGCannonsSound = SKAudioNode(fileNamed: "bgCannons")
        bGCannonsSound.runAction(SKAction.play())
        bGCannonsSound.autoplayLooped = true
        
        bGCannonsSound.removeFromParent()
        self.addChild(bGCannonsSound)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Brings user back to main menu
        let game: GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .AspectFit
        let transition: SKTransition = SKTransition.doorsOpenVerticalWithDuration(3.0)
        self.view?.presentScene(game, transition: transition)
    }
}
