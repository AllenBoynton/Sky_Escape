//
//  MainMenu.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/20/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    var infoButton = SKSpriteNode()
    var node = SKNode()
    
    override func didMoveToView(view: SKView) {
        
        self.runAction(SKAction.playSoundFileNamed("bgMusic", waitForCompletion: true))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            
            // Info button to show credits
            infoButton = SKScene(fileNamed: "MainMenu")!.childNodeWithName("info") as! SKSpriteNode
            infoButton.zPosition = 1000
            infoButton.name = "InfoButton"
            
            infoButton.removeFromParent()
            self.addChild(infoButton)
            
            let node = self.nodeAtPoint(location)
            if (node.name == "InfoButton") {
                
                let info: CreditsScene = CreditsScene(fileNamed: "CreditsScene")!
                info.scaleMode = .AspectFit
                let transition: SKTransition = SKTransition.doorsOpenHorizontalWithDuration(3.0)
                self.view?.presentScene(info, transition: transition)
            }
            
            let game: InstructionScene = InstructionScene(fileNamed: "InstructionScene")!
            game.scaleMode = .AspectFit
            let transition: SKTransition = SKTransition.doorsOpenHorizontalWithDuration(3.0)
            self.view?.presentScene(game, transition: transition)
        }
    }
}
