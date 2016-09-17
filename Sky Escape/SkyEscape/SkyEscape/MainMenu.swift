//
//  MainMenu.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/20/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    override func didMoveToView(view: SKView) {
        
        self.addChild(self.infoButtonNode())
        
        self.runAction(SKAction.playSoundFileNamed("bgMusic", waitForCompletion: true))
    }
    
    // Info button to show credits
    func infoButtonNode() -> SKSpriteNode {
        
        let infoNode: SKSpriteNode = SKSpriteNode(imageNamed: "info")
        infoNode.position = CGPoint(x: self.frame.width - infoNode.size.width / 2, y: self.frame.height - infoNode.size.height / 2)
        infoNode.size = CGSize(width: 95, height: 95)
        infoNode.zPosition = 5
        infoNode.name = "infoButtonNode"
        
        return infoNode
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            
            let node = self.nodeAtPoint(location)
            
            if (node.name! == "infoButtonNode") {
                
                let info: CreditsScene = CreditsScene(fileNamed: "CreditsScene")!
                info.scaleMode = .AspectFit
                let transition: SKTransition = SKTransition.doorsOpenHorizontalWithDuration(2.0)
                self.view?.presentScene(info, transition: transition)
            }
            else {
                
                let game: InstructionScene = InstructionScene(fileNamed: "InstructionScene")!
                game.scaleMode = .AspectFit
                let transition: SKTransition = SKTransition.doorsOpenHorizontalWithDuration(3.0)
                self.view?.presentScene(game, transition: transition)
            }
        }
    }
}
