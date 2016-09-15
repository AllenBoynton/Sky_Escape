//
//  InstructionScene.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/23/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class InstructionScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        //init
        self.runAction(SKAction.playSoundFileNamed("bGCannons", waitForCompletion: true))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Brings user back to main menu
        let game: GameScene = GameScene(fileNamed: "GameScene")!
        game.scaleMode = .AspectFit
        let transition: SKTransition = SKTransition.doorsOpenVerticalWithDuration(3.0)
        self.view?.presentScene(game, transition: transition)
    }
}
