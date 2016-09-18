//
//  EnemyPlanes.swift
//  SkyEscape
//
//  Created by Allen Boynton on 9/18/16.
//  Copyright © 2016 Full Sail. All rights reserved.
//

import SpriteKit

class EnemyPlanes: GameScene {
    
    var enemyPlanes: [SKSpriteNode] = []
    var newEnemy: SKSpriteNode!

    // Generate enemy fighter planes
    func spawnEnemyPlanes() -> SKSpriteNode {
        
        let enemy1 = SKScene(fileNamed: "Enemy1")!.childNodeWithName("enemy1")! as! SKSpriteNode
        let enemy2 = SKScene(fileNamed: "Enemy2")!.childNodeWithName("enemy2")! as! SKSpriteNode
        let enemy3 = SKScene(fileNamed: "Enemy3")!.childNodeWithName("enemy3")! as! SKSpriteNode
        let enemy4 = SKScene(fileNamed: "Enemy4")!.childNodeWithName("enemy4")! as! SKSpriteNode
        
        enemyPlanes = [enemy1, enemy2, enemy3, enemy4]
        
        // Generate a random index
        let randomIndex = Int(arc4random_uniform(UInt32(enemyPlanes.count)))
        
        // Get a random enemy
        newEnemy = (enemyPlanes[randomIndex])
        newEnemy.name = "EnemyPlanes"
        newEnemy.setScale(0.25)
        newEnemy.zPosition = 90
        
        // Calculate random spawn points for air enemies
        let randomY = CGFloat(arc4random_uniform(650) + 350)
        newEnemy.position = CGPoint(x: self.size.width, y: randomY)
        
        // Added randomEnemy's physics
//        newEnemy.physicsBody = SKPhysicsBody(rectangleOfSize: newEnemy.size)
//        newEnemy.physicsBody?.dynamic = false
//        newEnemy.physicsBody?.categoryBitMask = PhysicsCategory.EnemyMask
//        newEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.BulletMask | PhysicsCategory.BombMask | PhysicsCategory.SkyBombMask
//        newEnemy.physicsBody?.collisionBitMask = 0x0
        
        // Move enemies forward with random intervals
        let actualDuration = random(min: 3.0, max: 6.0)
        
        // Create a path func for planes to randomly follow {
        let actionMove = SKAction.moveTo(CGPoint(x: -newEnemy.size.width / 2, y: randomY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        newEnemy.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        // Add plane sound
        self.runAction(SKAction.playSoundFileNamed("airplanep51", waitForCompletion: false))
        
        shoot()
        
        return newEnemy
    }
    
    // Shoot in direction of Player
    func shoot() -> SKSpriteNode {
        
        enemyFire = SKScene(fileNamed: "EnemyFire")!.childNodeWithName("bullet")! as! SKSpriteNode
        
        // Positioning enemyFire to randomEnemy group
        enemyFire.position = CGPointMake(newEnemy.position.x, newEnemy.position.y)
        
        enemyFire.name = "EnemyFire"
        enemyFire.setScale(0.2)
        enemyFire.zPosition = 100
        
        enemyFire.removeFromParent()
        self.addChild(enemyFire) // Generate enemy fire
        
        // Added enemy's fire physics
//        enemyFire.physicsBody = SKPhysicsBody(rectangleOfSize: enemyFire.size)
//        enemyFire.physicsBody?.dynamic = false
//        enemyFire.physicsBody?.usesPreciseCollisionDetection = true
//        enemyFire.physicsBody?.categoryBitMask = PhysicsCategory.EnemyFire
//        enemyFire.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerMask
//        enemyFire.physicsBody?.collisionBitMask = PhysicsCategory.PlayerMask
        
        // Change attributes
        enemyFire.color = UIColor.yellowColor()
        
        // Shoot em up!
        let action = SKAction.moveToX(-50, duration: 1.0)
        let actionDone = SKAction.removeFromParent()
        enemyFire.runAction(SKAction.sequence([action, actionDone]))
        
        // Add gun sound
        self.runAction(SKAction.playSoundFileNamed("planeMachineGun", waitForCompletion: true))
        
        return enemyFire
    }
}
