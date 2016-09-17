//
//  GameScene.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/3/16.
//  Copyright (c) 2016 Full Sail. All rights reserved.
//

import SpriteKit
import GameKit


// Protocol to inform the delegate GameVC if a game is over
protocol GameSceneDelegate {
    func showLeaderBoard()
}

// Binary connections for collision and colliding
struct PhysicsCategory {
    
    static let Ground1     : UInt32 = 1     //0x1 << 0
    static let MyBullets2  : UInt32 = 2     //0x1 << 1
    static let MyPlane4    : UInt32 = 4     //0x1 << 2
    static let Enemy8      : UInt32 = 8     //0x1 << 3
    static let EnemyFire16 : UInt32 = 16    //0x1 << 4
    static let PowerUp32   : UInt32 = 32    //0x1 << 5
    static let Bombs64     : UInt32 = 64    //0x1 << 6
    static let Turret128   : UInt32 = 128   //0x1 << 7
    static let Soldiers256 : UInt32 = 256   //0x1 << 8
    static let Missiles512 : UInt32 = 512   //0x1 << 9
    static let SkyBombs1024: UInt32 = 1024  //0x1 << 10
    static let All         : UInt32 = UInt32.max // all nodes
}

// HUD global variables
var lifeNodes: [SKSpriteNode] = []
var remainingNodes = SKSpriteNode()
var remainingLives = 3
let maxHealth = 50
let healthBarWidth: CGFloat = 170
let healthBarHeight: CGFloat = 10
let playerHealthBar = SKSpriteNode()

let darkenOpacity: CGFloat = 0.5
let darkenDuration: CFTimeInterval = 2


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameCenterDelegate : GameSceneDelegate?
    
    
    /************************** Property constants declared ************/
    // MARK: - Property constants declared
    
    // SK Physics body
    var contactBody1 = SKPhysicsBody()
    var contactBody2 = SKPhysicsBody()
    
    // Location for touch screen
    var touchLocation = CGPointZero
    
    // Image atlas's for animation
    var animation = SKAction()
    var frames = [SKTexture]()
    
    // Atlas's instantiated
    var attackAtlas = SKTextureAtlas()
    var allyAtlas = SKTextureAtlas()
    var enemyArrayAtlas = SKTextureAtlas(named: "EnemyArray")
    var enemy1Atlas = SKTextureAtlas(named: "Enemy1Attack")
    var enemy2Atlas = SKTextureAtlas(named: "Enemy2Attack")
    var enemyDie1Atlas = SKTextureAtlas(named: "Enemy1Die")
    var enemyDie2Atlas = SKTextureAtlas(named: "Enemy2Die")
    var soldierShootAtlas = SKTextureAtlas(named: "SoldierShoot")
    var soldierWalkAtlas = SKTextureAtlas(named: "SoldierWalk")
    var turretAtlas = SKTextureAtlas(named: "Turret")
    var powerUpsAtlas = SKTextureAtlas(named: "PowerUps")
    
    // Emitter objects
    var smokeTrail = SKEmitterNode(fileNamed: "SmokeTrail")!
    var smoke = SKEmitterNode(fileNamed: "Smoke")!
    var explode = SKEmitterNode(fileNamed: "Explode")!
    var explosion = SKEmitterNode(fileNamed: "FireExplosion")!
    
    // Animation setup class
    let node = SKNode()
    var player = SKSpriteNode()
    var textureArray = [SKTexture]()
    
    // Player's weapons & allies
    var bullet = SKSpriteNode()
    var bombs = SKSpriteNode()
    
    // My backgrounds
    var myBackground = SKTexture()
    var midground = SKTexture()
    var foreground = SKTexture()
    
    // Enemy planes - static, straight
    var enemy = SKSpriteNode()
    var myEnemy1 = SKSpriteNode()
    var myEnemy2 = SKSpriteNode()
    var enemyArray = [SKTexture]()
    var randomEnemy = SKSpriteNode()
    var enemyFire = SKSpriteNode()
    
    // Ally planes
    var randomAlly = SKSpriteNode()
    var wingmenArray = [SKTexture]()
    
    // Sky nodes
    var powerUps = SKSpriteNode()
    var coins = SKSpriteNode()
    
    // Ground troops
    var turret = SKSpriteNode()
    var missiles = SKSpriteNode()
    var soldierWalk = SKSpriteNode()
    var soldierShoot = SKSpriteNode()
    
    // Game metering GUI
    var myCamera = SKCameraNode()
    var score: Int64 = 0
    var powerUpCount = 0
    var coinCount = 0
    var health = 50
    var playerHP = maxHealth
    var died = Bool()
    var gamePaused = Bool()
    var gameStarted = Bool()
    var gameOver = Bool()
    
    // Labels and images
    var healthLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var powerUpLabel = SKLabelNode()
    var coinImage = SKSpriteNode()
    var coinCountLbl = SKLabelNode()
    var display = SKSpriteNode()
    var pauseNode = SKSpriteNode()
    var pauseButton = SKSpriteNode()
    var darkenLayer: SKSpriteNode?
    var startButton = SKSpriteNode()
    var restartButton = SKSpriteNode()
    var gameOverLabel: SKLabelNode?
    
    
    /********************************* Restart Scene funcs *********************************/
    // MARK: - Restart scenes
    
    // Function to restart scene
    func restartScene() {
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = true
        score = 0
        remainingLives = 3
        health = 20
        startScene()
    }
    
    // Starting scene, passed to didMoveToView
    func startScene() {
        
        // Sets the physics delegate and physics body
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsWorld.contactDelegate = self // Physics delegate set
        
        // Backgroung color set with RGB
        backgroundColor = SKColor.init(red: 127/255, green: 189/255, blue: 248/255, alpha: 1.0)
        
        
        /********************************* Adding Scroll Background *********************************/
        // MARK: - Scroll Background
        
        // Adding scrolling Main Background
        createBackground()
        
        // Adding scrolling midground
        createMidground()
        
        // Adding scrolling foreground
        createForeground()
        
        // Tap to Start button
        startButton = SKSpriteNode(imageNamed: "start")
        startButton.zPosition = 1000
        startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        startButton.name = "StartButton"
        
        startButton.removeFromParent()
        self.addChild(startButton)
    }
    
    /************************************* didMoveToView Function **********************************/
    // MARK: - didMoveToView
    
    override func didMoveToView(view: SKView) {
        
        startScene()
    }
    
    
    /*********************************** touchesBegan Function **************************************/
    // MARK: - touchesBegan
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if gameStarted == false {
            
            gameStarted = true
            
            // Remove button
            startButton.removeFromParent()
            
            touchLocation = touches.first!.locationInNode(self)
            
            for touch: AnyObject in touches {
                let location = (touch as! UITouch).locationInNode(self)
                
                let node = self.nodeAtPoint(location)
                
                if (node.name! == "PauseButton") || (node.name! == "PauseButtonContainer") {
                    showPauseAlert()
                }
                
                /* function opens up the HUD and makes the button accessible
                 also, has displays for health and score. */
                createHUD()
                
                /* Allows to tap on screen and plane will present
                 at that axis and shoot at point touched */
                
                player.position.y = location.y // Allows a tap to touch on the y axis
                player.position.x = location.x // Allows a tap to touch on the x axis
                
                
                // Call function when play sound
                self.runAction(SKAction.playSoundFileNamed("startGame", waitForCompletion: false))
                
                // Double tap screen to drop bomb
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.fireBombs))
                self.view!.addGestureRecognizer(tapRecognizer)
                tapRecognizer.numberOfTapsRequired = 2

                
                /******************************** Spawning Nodes *********************************/
                // MARK: - Spawning
                
                // Call function to setup player's plane
                setupPlayer()
                
                self.addChild(playerHealthBar)
                
                
                /********************************* Spawn Timers *********************************/
                // MARK: - Spawn Timers
                
                // Spawning wingman timer call
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(spawnWingman),
                    SKAction.waitForDuration(12)
                    ])
                    ))
                
                // Spawning enemy planes
                let xSpawn = randomBetweenNumbers(2.0, secondNum: 8.0)
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(spawnEnemyPlanes),
                    SKAction.waitForDuration(Double(xSpawn))
                    ])
                    ))
                
                // Spawning enemy fire timer call
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(spawnEnemyFire),
                    SKAction.waitForDuration(1.5)
                    ])
                    ))
                
                // Sky bomb spawn timer
                let xSpawn2 = randomBetweenNumbers(10.0, secondNum: 20.0)
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(skyExplosions),
                    SKAction.waitForDuration(Double(xSpawn2))
                    ])
                    ))
                
                // Soldier timer
                let xSpawn3 = randomBetweenNumbers(2.0, secondNum: 10.0)
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(setupSoldiers),
                    SKAction.waitForDuration(Double(xSpawn3))
                    ])
                    ))
                
                // Shooting soldiers spawn timer
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(setupShooters),
                    SKAction.waitForDuration(20)
                    ])
                    ))
                
                // Turret spawn timer
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(setupTurret),
                    SKAction.waitForDuration(30)
                    ])
                    ))

                // Turret missile spawn timer
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(spawnTurretMissiles),
                    SKAction.waitForDuration(5.0)
                    ])
                    ))
                
                // Spawning power up timer call
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(spawnPowerUps),
                    SKAction.waitForDuration(120)
                    ])
                    ))
                
                
                if died == true {
                    
                    if restartButton.containsPoint(location) {
                        restartScene()
                    }
                }
            }
        }
    }
    
    
    /********************************* touchesMoved Function **************************************/
    // MARK: - touchesMoved
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchLocation = touches.first!.locationInNode(self)
        
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            
            /* Allows to drag on screen and plane will follow
            that axis and shoot at point when released */
            player.position.y = location.y // Allows a tap to touch on the y axis
            player.position.x = location.x
            
            fireBullets()
        }
    }
    
    
    /********************************* touchesEnded Function **************************************/
    // MARK: - touchesEnded
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {}
    
    
    /*********************************** Update Function *****************************************/
    // MARK: - Update Function
    
    // Update for animations and positions
    override func update(currentTime: NSTimeInterval) {
        
        if !self.gamePaused && !self.gameOver {
            
            // Move backgrounds
            moveBackground()
            moveMidground()
            moveForeground()
            
            // Plane's smoketrail will follow it as updating occurs
            smokeTrail.position = CGPoint(x: player.position.x - 80, y: player.position.y - 10)
            smokeTrail.zPosition = 90
            smokeTrail.targetNode = self
            smokeTrail.removeFromParent()
            addChild(smokeTrail)
            
            // Healthbar GUI
            playerHealthBar.position = CGPoint(x: player.position.x, y: player.position.y - player.size.height / 2 + 30)
            playerHealthBar.zPosition = 100
            updateHealthBar(playerHealthBar, withHealthPoints: playerHP)
            
            // Adding to gameplay health attributes & score
            healthLabel.text = "Health: \(health)"
            scoreLabel.text = "Score: \(score)"
            
            // Changes health label red if too low
            if (health <= 10) {
                healthLabel.fontColor = SKColor.redColor()
            }
        }
    }
    

    /********************************* Background Functions *********************************/
    // MARK: - Background Functions
    
    // Adding scrolling background
    func createBackground() {
        
        myBackground = SKTexture(imageNamed: "clouds")
        
        for i in 0...1 {
            let background = SKSpriteNode(texture: myBackground)
            background.name = "Background"
            background.zPosition = 0
            background.anchorPoint = CGPointZero
            background.position = CGPoint(x: (myBackground.size().width * CGFloat(i)) - CGFloat(1 * i), y: 0)
            
            background.removeFromParent()
            self.addChild(background)
            
            // Create physics body
            background.physicsBody = SKPhysicsBody(rectangleOfSize: background.size)
            background.physicsBody?.categoryBitMask = PhysicsCategory.Ground1
            background.physicsBody?.contactTestBitMask = 0
            background.physicsBody?.collisionBitMask = 0
            background.physicsBody?.dynamic = false
        }
    }
    
    // Puts createMyBackground in motion
    func moveBackground() {
        
        self.enumerateChildNodesWithName("Background", usingBlock: ({
            (node, error) in
            
            node.position.x -= 1.0
            
            if node.position.x < -((self.scene?.size.width)!) {
                
                node.position.x += (self.scene?.size.width)!
            }
        }))
    }

    // Adding scrolling midground
    func createMidground() {
        
        midground = SKTexture(imageNamed: "mountains")
       
        for i in 0...2 {
            let ground = SKSpriteNode(texture: midground)
            ground.name = "Midground"
            ground.zPosition = 20
            ground.position = CGPoint(x: (midground.size().width / 2.0 + (midground.size().width * CGFloat(i))), y: midground.size().height / 2)
            
            ground.removeFromParent()
            self.addChild(ground)
            
            // Create physics body
            ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
            ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground1
            ground.physicsBody?.contactTestBitMask = 0
            ground.physicsBody?.collisionBitMask = 0
            ground.physicsBody?.dynamic = false
        }
    }
    
    // Puts createMyMidground in motion
    func moveMidground() {
        
        self.enumerateChildNodesWithName("Midground", usingBlock: ({
            (node, error) in
            
            node.position.x -= 2.0
            
            if node.position.x < -((self.scene?.size.width)!) {
                
                node.position.x += (self.scene?.size.width)! * 2
            }
        }))
    }
    
    // Adding scrolling foreground
    func createForeground() {
        
        foreground = SKTexture(imageNamed: "lonelytree")
        
        for i in 0...6 {
            let ground = SKSpriteNode(texture: foreground)
            ground.name = "Foreground"
            ground.zPosition = 30
            ground.position = CGPoint(x: (foreground.size().width / 2.0 + (foreground.size().width * CGFloat(i))), y: foreground.size().height / 2)
            
            ground.removeFromParent()
            self.addChild(ground)
            
            // Create physics body
            ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
            ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground1
            ground.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
            ground.physicsBody?.collisionBitMask = 0
            ground.physicsBody?.dynamic = false
        }
    }
    
    // Puts createMyForeground in motion
    func moveForeground() {
        
        self.enumerateChildNodesWithName("Foreground", usingBlock: ({
            (node, error) in
            
            node.position.x -= 6.0
            
            if node.position.x < -((self.scene?.size.width)!) {
                
                node.position.x += (self.scene?.size.width)! * 6
            }
        }))
    }
    
    
    /*********************************** Spawning Functions *********************************/
    // MARK: - Spawning nodes on our side - Functions

    // From the Player class
    func setupPlayer() {
        
        attackAtlas = SKTextureAtlas(named: "Attack.atlas")
        
        for i in 1...attackAtlas.textureNames.count {
            let player = "MyFokker\(i).png"
            textureArray.append(SKTexture(imageNamed: player))
        }
        
        player = SKSpriteNode(texture: textureArray[0])
        player.position = CGPoint(x: self.size.width / 6, y: self.size.height / 2)
        player.name = "Player"
        player.setScale(0.8)
        player.zPosition = 100

        // Body physics for player's planes
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.dynamic = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.MyPlane4
        player.physicsBody?.contactTestBitMask = PhysicsCategory.EnemyFire16 |
            PhysicsCategory.Enemy8 | PhysicsCategory.Missiles512 | PhysicsCategory.Ground1 | PhysicsCategory.PowerUp32 | PhysicsCategory.SkyBombs1024
        player.physicsBody?.collisionBitMask = 0
        
        self.addChild(player) // Add our player to the scene
        
        // Animation action
        let animateAction = SKAction.animateWithTextures(textureArray, timePerFrame: 0.05)
        let animateDone = SKAction.removeFromParent()
        self.runAction(SKAction.sequence([animateAction, animateDone]))
        
        self.runAction(SKAction.playSoundFileNamed("biplaneFlying", waitForCompletion: false))
    }
    
    // Create the ammo for our plane to fire
    func fireBullets() {
        
        bullet = SKSpriteNode(imageNamed: "fireBullet")

        bullet.position = CGPoint(x: player.position.x + 70, y: player.position.y + 20)
        bullet.name = "FireBullet"
        bullet.setScale(0.8)
        bullet.zPosition = 100
        
        // Body physics for plane's bulets
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody?.dynamic = false
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.MyBullets2
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy8
        bullet.physicsBody?.collisionBitMask = 0
        
        self.addChild(bullet) // Add bullet to the scene
        
        // Shoot em up!
        let action = SKAction.moveToX(self.size.width + 150, duration: 1.5)
        let actionDone = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([action, actionDone]))
        
        // Add gun sound
        self.runAction(SKAction.playSoundFileNamed("shoot", waitForCompletion: false))
    }

    // Create the bombs for our plane to drop
    func fireBombs() {
        
        bombs = SKSpriteNode(imageNamed: "bomb")
        
        bombs.position = CGPoint(x: player.position.x, y: player.position.y)
        bombs.name = "Bombs"
        bombs.setScale(0.1)
        bombs.zPosition = 100
        
        // Body physics for plane's bombs
        bombs.physicsBody = SKPhysicsBody(rectangleOfSize: bombs.size)
        bombs.physicsBody?.dynamic = false
        bombs.physicsBody?.categoryBitMask = PhysicsCategory.Bombs64
        bombs.physicsBody?.contactTestBitMask = PhysicsCategory.Turret128 | PhysicsCategory.Soldiers256 | PhysicsCategory.Enemy8 | PhysicsCategory.Ground1 | PhysicsCategory.Missiles512
        bombs.physicsBody?.collisionBitMask = 0
        
        bombs.removeFromParent()
        addChild(bombs) // Add bombs to the scene
        
        let moveBombAction = SKAction.moveToY(-100, duration: 2.0)
        let removeBombAction = SKAction.removeFromParent()
        bombs.runAction(SKAction.sequence([moveBombAction,removeBombAction]))
    
        // Add gun sound
        self.runAction(SKAction.playSoundFileNamed("bombaway", waitForCompletion: true))
    }
    
    // Adding ally forces in background
    func spawnWingman() {
        
        allyAtlas = SKTextureAtlas(named: "AllyPlanes")
        
        // Wingmen passby's in the distance
        for i in 1...allyAtlas.textureNames.count {
            let ally = "wingman\(i).png"
            
            wingmenArray.append(SKTexture(imageNamed: ally))
        }
        
        // Generate a random index
        let randomIndex = Int(arc4random_uniform(UInt32(wingmenArray.count)))
        
        // Get a random ally
        randomAlly = SKSpriteNode(texture: wingmenArray[randomIndex])
        
        randomAlly.zPosition = 22
        randomAlly.setScale(0.3)
        
        // Calculate random spawn points for wingmen
        let random = CGFloat(arc4random_uniform(700) + 250)
        randomAlly.position = CGPoint(x: -self.size.width, y: random)
        
        // Body physics for plane's bombs
        randomAlly.physicsBody = SKPhysicsBody(rectangleOfSize: randomAlly.size)
        randomAlly.physicsBody?.dynamic = false
        randomAlly.physicsBody?.categoryBitMask = PhysicsCategory.MyPlane4
        randomAlly.physicsBody?.contactTestBitMask = 0
        randomAlly.physicsBody?.collisionBitMask = 0
        
        randomAlly.removeFromParent()
        addChild(randomAlly) // Generate the random wingman
        
        // Move enemies forward with random intervals
        let wingmanDuration = randomBetweenNumbers(12.0, secondNum: 24.0)
        
        // SKAction for the spritenode itself...to move forward
        let action = SKAction.moveToX(self.size.width + 80, duration: NSTimeInterval(wingmanDuration))
        let actionDone = SKAction.removeFromParent()
        randomAlly.runAction(SKAction.sequence([action, actionDone]))
    }
    
    // Spawning a bonus star
    func spawnPowerUps() {
        
        // Add user's animated powerUp
        powerUps = SKScene(fileNamed: "PowerUps")!.childNodeWithName("powerUp")! as! SKSpriteNode
        
        // Star position off screen
        let xPos = randomBetweenNumbers(0, secondNum: self.frame.width )
        let randomY = CGFloat(arc4random_uniform(700) + 250)
        
        // Sky bomb position on screen
        powerUps.position = CGPoint(x: xPos, y: randomY)
        powerUps.name = "PowerUps"
        powerUps.setScale(1.0)
        powerUps.zPosition = 100
        
        powerUps.removeFromParent()
        self.addChild(powerUps) // Add power ups to the scene
        
        // Body physics for power ups
        powerUps.physicsBody = SKPhysicsBody(circleOfRadius: size.height / 2)
        powerUps.physicsBody?.dynamic = false
        powerUps.physicsBody?.categoryBitMask = PhysicsCategory.PowerUp32
        powerUps.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
        powerUps.physicsBody?.collisionBitMask = 0
        
        // Add PowerUp sound
        self.runAction(SKAction.playSoundFileNamed("powerUp", waitForCompletion: false) )
    }
    

    /*********************************** Spawning Enemies *********************************/
    // MARK: - Spawning Enemy Functions
    
    // Spawn sky nodes
    func skyExplosions() {
        
        explosion = SKEmitterNode(fileNamed: "FireExplosion")!
        
        // Sky explosions of a normal battle
        explosion.name = "Explosion"
        explosion.zPosition = 75
        
        let xPos = randomBetweenNumbers(0, secondNum: self.frame.width )
        let randomY = CGFloat(arc4random_uniform(700) + 250)
        
        // Sky bomb position on screen
        explosion.position = CGPoint(x: xPos, y: randomY)
        
        // Body physics for plane's bombs
        explosion.physicsBody = SKPhysicsBody(circleOfRadius: size.height/2)
        explosion.physicsBody?.dynamic = false
        explosion.physicsBody?.categoryBitMask = PhysicsCategory.SkyBombs1024
        explosion.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy8 | PhysicsCategory.MyPlane4
        explosion.physicsBody?.collisionBitMask = 0
        
        explosion.removeFromParent()
        self.addChild(explosion) // Add sky bomb to the scene
        
        // Add sky explosion sound
        self.runAction(SKAction.playSoundFileNamed("skyBoom", waitForCompletion: false) )
    }
    
    // Generate enemy fighter planes
    func spawnEnemyPlanes() {
        
        for i in 1...enemyArrayAtlas.textureNames.count {
            let enemy = "enemy\(i)"
            enemyArray.append(SKTexture(imageNamed: enemy))
        }
        
        // Generate a random index
        let randomIndex = Int(arc4random_uniform(UInt32(enemyArray.count)))
        
        // Get a random enemy
        randomEnemy = SKSpriteNode(texture: enemyArray[randomIndex])
        randomEnemy.name = "EnemyPlanes"
        randomEnemy.setScale(0.25)
        randomEnemy.zPosition = 90
        
        // Calculate random spawn points for air enemies
        let randomY = CGFloat(arc4random_uniform(650) + 350)
        randomEnemy.position = CGPoint(x: self.size.width, y: randomY)
        
        // Added randomEnemy's physics
        randomEnemy.physicsBody = SKPhysicsBody(rectangleOfSize: randomEnemy.size)
        randomEnemy.physicsBody?.dynamic = false
        randomEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy8
        randomEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.MyBullets2 | PhysicsCategory.Bombs64 | PhysicsCategory.SkyBombs1024
        randomEnemy.physicsBody?.collisionBitMask = 0
        
        // Add enemies
        self.addChild(randomEnemy)
        
        // Move enemies forward with random intervals
        let actualDuration = random(min: 3.0, max: 6.0)
        
        // Create a path func for planes to randomly follow {
        let actionMove = SKAction.moveTo(CGPoint(x: -randomEnemy.size.width / 2, y: randomY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        randomEnemy.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    
        // Add plane sound
        self.runAction(SKAction.playSoundFileNamed("airplanep51", waitForCompletion: false))
        
        spawnEnemyFire()
    }
    
    // Function to allow all enemy planes to get setup and fire
    func spawnEnemyFire() {
        
        enemyFire = SKSpriteNode(imageNamed: "bullet")
        
        // Positioning enemyFire to randomEnemy group
        enemyFire.position = CGPointMake(randomEnemy.position.x - 75, randomEnemy.position.y)
        
        enemyFire.name = "EnemyFire"
        enemyFire.setScale(0.2)
        enemyFire.zPosition = 100
        
        enemyFire.removeFromParent()
        self.addChild(enemyFire) // Generate enemy fire
        
        // Added enemy's fire physics
        enemyFire.physicsBody = SKPhysicsBody(rectangleOfSize: enemyFire.size)
        enemyFire.physicsBody?.categoryBitMask = PhysicsCategory.EnemyFire16
        enemyFire.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
        enemyFire.physicsBody?.collisionBitMask = 0
        enemyFire.physicsBody?.dynamic = false
        
        // Change attributes
        enemyFire.color = UIColor.yellowColor()
        enemyFire.colorBlendFactor = 1.0
        
        // Shoot em up!
        let action = SKAction.moveToX(-50, duration: 1.0)
        let actionDone = SKAction.removeFromParent()
        enemyFire.runAction(SKAction.sequence([action, actionDone]))
        
        // Add gun sound
        self.runAction(SKAction.playSoundFileNamed("planeMachineGun", waitForCompletion: true))
    }

    // Setup turret to be able to shoot missiles
    func setupTurret() {
        
        // Setup shooting turret
        turret = SKScene(fileNamed: "Turrets")!.childNodeWithName("turret")! as! SKSpriteNode
        
        // Attempt to keep turret looking stationary
        turret.position = CGPoint(x: self.size.width, y: 240)
        turret.name = "Turret"
        turret.zPosition = 125
        
        turret.removeFromParent()
        addChild(turret) // Add turret to scene
        
        // Added turret's physics
        turret.physicsBody = SKPhysicsBody(rectangleOfSize: turret.size)
        turret.physicsBody?.dynamic = false
        turret.physicsBody?.categoryBitMask = PhysicsCategory.Turret128
        turret.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4 | PhysicsCategory.MyBullets2 | PhysicsCategory.Bombs64
        turret.physicsBody?.collisionBitMask = 0
        
        // Move tank forward and fire
        let action = SKAction.moveTo(CGPoint(x: -100, y: 230), duration: 45)
        let actionDone = SKAction.removeFromParent()
        turret.runAction(SKAction.sequence([action, actionDone]))
    }
    
    // Spawn enemy tank missiles
    func spawnTurretMissiles() {
        
        // Spawning an enemy tank's anti-aircraft missiles
        missiles = SKScene(fileNamed: "Missiles")!.childNodeWithName("turretMissile")! as! SKSpriteNode
        missiles.name = "TurretMissiles"
        missiles.setScale(0.5)
        missiles.zPosition = 149
        
        missiles.position = CGPoint(x: turret.position.x - 30, y: turret.position.y + 20)
        
        missiles.removeFromParent()
        self.addChild(missiles) // Generate tank missile
        
        // Added turret's missile physics
        missiles.physicsBody = SKPhysicsBody(rectangleOfSize: missiles.size)
        missiles.physicsBody?.dynamic = false
        missiles.physicsBody?.categoryBitMask = PhysicsCategory.Missiles512
        missiles.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
        missiles.physicsBody?.collisionBitMask = 0
        
        // Shoot em up!
        let action = SKAction.moveTo(CGPoint(x: -50, y: self.size.height + 80), duration: 3.0)
        let actionDone = SKAction.removeFromParent()
        missiles.runAction(SKAction.sequence([action, actionDone]))
    }
    
    // Spawning a walking soldier
    func setupSoldiers() {
        
        // Allows for random y axis spawning
        let yPos = randomBetweenNumbers(100, secondNum: 225)

        // Add user's animated walking soldiers
        soldierWalk = SKScene(fileNamed: "Soldiers")!.childNodeWithName("soldierWalk")! as! SKSpriteNode
        
        // Sky bomb position on screen
        soldierWalk.position = CGPoint(x: self.frame.width, y: yPos)
        soldierWalk.name = "Soldiers"
        soldierWalk.zPosition = 130
        
        soldierWalk.removeFromParent()
        self.addChild(soldierWalk)
        
        // Added soldier's physics
        soldierWalk.physicsBody = SKPhysicsBody(rectangleOfSize: soldierWalk.size)
        soldierWalk.physicsBody?.dynamic = false
        soldierWalk.physicsBody?.categoryBitMask = PhysicsCategory.Soldiers256
        soldierWalk.physicsBody?.contactTestBitMask = PhysicsCategory.Bombs64 | PhysicsCategory.MyBullets2 | PhysicsCategory.MyPlane4
        soldierWalk.physicsBody?.collisionBitMask = 0
        
        // Move soldiers forward
        let walkAcrossScreen = SKAction.moveTo(CGPoint(x: -40, y: yPos), duration: 20)
        let actionDone = SKAction.removeFromParent()
        soldierWalk.runAction(SKAction.sequence([walkAcrossScreen, actionDone]))
    }
    
    // Spawning a walking soldier
    func setupShooters() {
        
        // Add user's animated walking soldiers
        soldierShoot = SKScene(fileNamed: "Soldiers")!.childNodeWithName("soldierShoot")! as! SKSpriteNode
        
        // Sky bomb position on screen
        soldierShoot.position = CGPoint(x: self.frame.width, y: 155)
        soldierShoot.name = "Shooters"
        soldierShoot.zPosition = 120
        
        soldierShoot.removeFromParent()
        self.addChild(soldierShoot)
        
        // Added shooter's physics
        soldierShoot.physicsBody = SKPhysicsBody(rectangleOfSize: soldierShoot.size)
        soldierShoot.physicsBody?.dynamic = false
        soldierShoot.physicsBody?.categoryBitMask = PhysicsCategory.Soldiers256
        soldierShoot.physicsBody?.contactTestBitMask = PhysicsCategory.Bombs64 | PhysicsCategory.MyBullets2 | PhysicsCategory.MyPlane4
        soldierShoot.physicsBody?.collisionBitMask = 0
        
        // Move soldiers forward
        let shootPlanes = SKAction.moveTo(CGPoint(x: -40, y: 185), duration: 35)
        let actionRepeat = SKAction.removeFromParent()
        soldierShoot.runAction(SKAction.sequence([shootPlanes, actionRepeat]))
    }
    
    
    /************************************ didBeginContact *****************************************/
    // MARK: - didBeginContact
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        // beginContact constants
        contactBody1 = contact.bodyA
        contactBody2 = contact.bodyB
        
        // Perform an if/else so we do not have to repeat and reverse the statements
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            
            contactBody1 = contact.bodyA
            contactBody2 = contact.bodyB
        } else {
            contactBody1 = contact.bodyB
            contactBody2 = contact.bodyA
        }
        
        if ((contactBody1.categoryBitMask & PhysicsCategory.Ground1 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.MyPlane4 != 0)) {
            print("We hit the ground")
            
            blownUpOne()
            
            // Check points
            health = 0
            
            showGameOverAlert()
        }
        else if ((contactBody1.categoryBitMask & PhysicsCategory.MyBullets2 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.Enemy8 != 0)) {
            print("We shot the plane")
        
            blownUpBoth()
            
            // Hitting an the enemy adds score and health
            score += 1
        }
        else if ((contactBody1.categoryBitMask & PhysicsCategory.Bombs64 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.Turret128 != 0)) {
            print("Bomb hit turret")
            
            blownUpBoth()
            
             // Hitting an the enemy adds score and health
            score += 2
        }
        else if ((contactBody1.categoryBitMask & PhysicsCategory.MyBullets2 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.Turret128 != 0)) {
            print("Bullets hit turret")
            
            blownUpBoth()
            
            // Hitting an the enemy adds score and health
            score += 2
        }
        else if ((contactBody1.categoryBitMask & PhysicsCategory.MyBullets2 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.Soldiers256 != 0)) {
            print("We shot the soldiers")
            
            contactBody2.node?.removeFromParent()
            contactBody1.node?.removeFromParent()
            
            // Hitting an the enemy adds score
            score += 1
        }
        else if ((contactBody1.categoryBitMask & PhysicsCategory.Bombs64 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.Soldiers256 != 0)) {
            print("Bombs hit soldiers")
            
            explode = SKEmitterNode(fileNamed: "Explode")!
            explode.position = (contactBody2.node?.position)!
            
            explode.removeFromParent()
            self.addChild(explode)
            
            contactBody1.node?.removeFromParent()
            contactBody2.node?.removeFromParent()
            
            // Add crashing sound
            self.runAction(SKAction.playSoundFileNamed("crash", waitForCompletion: true))
            
            // Points per each soldier hit
            score += 1
        }
        else if ((contactBody1.categoryBitMask & PhysicsCategory.Bombs64 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.Ground1 != 0)) {
            print("Bomb hit the ground")
            
            explode = SKEmitterNode(fileNamed: "Explode")!
            explode.position = (contactBody1.node?.position)!
            
            runAction(SKAction.waitForDuration(2), completion: { self.explode.removeFromParent() })

            self.addChild(explode)
            
            contactBody1.node?.removeFromParent()
            
            // Add crashing sound
            self.runAction(SKAction.playSoundFileNamed("crash", waitForCompletion: true))
        }
        else if ((contactBody1.categoryBitMask & PhysicsCategory.MyPlane4 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.Enemy8 != 0)) {
            print("Planes collide")
            
            blownUpBoth()
        
            // Configure points
            showGameOverAlert()
        }
        else if ((contactBody1.categoryBitMask & PhysicsCategory.MyPlane4 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.EnemyFire16 != 0)) {
            print("Plane takes fire")
            
            explode = SKEmitterNode(fileNamed: "Explode")!
            
            explode.position = contactBody1.node!.position
            explode.removeFromParent()
            self.addChild(explode)
            
            contactBody2.node!.removeFromParent()
            
            // Add crashing sound
            self.runAction(SKAction.playSoundFileNamed("ricochet", waitForCompletion: true))
            
            health -= 1
            playerHP = max(0, health - 1)
        }
        else if ((contactBody1.categoryBitMask & PhysicsCategory.MyPlane4 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.PowerUp32 != 0)) {
            print("Plane makes contact with Power Up")
            
            explode = SKEmitterNode(fileNamed: "Explode")!
            explode.position = contactBody2.node!.position
            
            explode.removeFromParent()
            self.addChild(explode)
            
            contactBody2.node!.removeFromParent()
            
            // Add PowerUp sound
            self.runAction(SKAction.playSoundFileNamed("powerUp", waitForCompletion: true))
            
            // Points per star added to score and health
            health += 20
            powerUpCount += 1
            playerHP = max(0, health + 1)
        }
        else if ((contactBody1.categoryBitMask & PhysicsCategory.SkyBombs1024 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.Enemy8 != 0)) {
            print("SkyBomb hit enemy")
            
            blownUpOne()
        
            // Sky bomb hits enemy - we get points
            score += 1
        }
        else if ((contactBody1.categoryBitMask & PhysicsCategory.MyPlane4 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.SkyBombs1024 != 0)) {
            print("Skybomb hit us")
            
            blownUpOne()
        
             // Health/Score
            health -= 5
            playerHP = max(0, health - 5)
        }
        else if ((contactBody1.categoryBitMask & PhysicsCategory.MyPlane4 != 0) && (contactBody2.categoryBitMask & PhysicsCategory.Missiles512 != 0)) {
            print("Missile hit us")
            
            blownUpOne()
         
            // Points/Score
            health -= 10
            playerHP = max(0, health - 10)
        }
    }
    
    // Function for popular contact reaction - blowing up/crash
    func blownUpBoth() {
        
        explosion = SKEmitterNode(fileNamed: "FireExplosion")!
        smoke = SKEmitterNode(fileNamed: "Smoke")!
        
        explosion.position = (contactBody2.node?.position)!
        smoke.position = (contactBody2.node?.position)!
        
        self.addChild(explosion)
        self.addChild(smoke)
        
        contactBody1.node!.removeFromParent()
        contactBody2.node!.removeFromParent()
        
        runAction(SKAction.waitForDuration(2), completion: { self.explosion.removeFromParent() })
        runAction(SKAction.waitForDuration(3), completion: { self.smoke.removeFromParent() })
        
        // Add crashing sound
        self.runAction(SKAction.playSoundFileNamed("crash", waitForCompletion: true))
    }
    
    // Function for popular contact reaction - blowing up/crash
    func blownUpOne() {
        
        explosion = SKEmitterNode(fileNamed: "FireExplosion")!
        smoke = SKEmitterNode(fileNamed: "Smoke")!
        
        explosion.position = (contactBody2.node?.position)!
        smoke.position = (contactBody2.node?.position)!
        
        self.addChild(explosion)
        self.addChild(smoke)
        
        contactBody2.node!.removeFromParent()
        
        runAction(SKAction.waitForDuration(2), completion: { self.explosion.removeFromParent() })
        runAction(SKAction.waitForDuration(3), completion: { self.smoke.removeFromParent() })
        
        // Add crashing sound
        self.runAction(SKAction.playSoundFileNamed("crash", waitForCompletion: true))
    }

    
    /*************************************** GUI ******************************************/
    // Show Pause Alert
    
    // Show Pause Alert
    func showPauseAlert() {
        self.gamePaused = true
        let alert = UIAlertController(title: "Pause", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default)  { _ in
            self.gamePaused = false
            })
        self.view?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Function to give pause attributes within pause alert
    func holdGame() {
        if self.scene!.view?.paused == true {

            // Stop movement, fade out, move to center, fade in
            player.removeAllActions()
            self.player.runAction(SKAction.fadeOutWithDuration(1) , completion: {
                self.player.position = CGPointMake(self.size.width / 2, self.size.height / 2)
                self.player.runAction(SKAction.fadeInWithDuration(1), completion: {
                    self.scene!.view?.paused = false
                })
            })
        }
    }
    
    
    /*************************************** HUD ******************************************/
    // Heads Up Display

    // Heads Up Display attributes
    func createHUD() {
        
        // Adding HUD with pause
        display = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.size.width, self.size.height * 0.06))
        display.anchorPoint = CGPointMake(0, 0)
        display.position = CGPointMake(0, self.size.height - display.size.height)
        display.zPosition = 200
        
        // Amount of lives
        let livesSize = CGSizeMake(display.size.height - 10, display.size.height - 10)
        for i in 0...remainingLives - 1{
            remainingNodes = SKSpriteNode(imageNamed: "life")
            remainingNodes.position = CGPointMake(remainingNodes.size.width * 3.0 * (1.0 + CGFloat(i) / 5), (display.size.height - 5) / 2)
            lifeNodes.append(remainingNodes)
            remainingNodes.size = livesSize
            remainingNodes.removeFromParent()
            display.addChild(remainingNodes)
        }
        
        // Pause button container
        pauseNode.position = CGPoint(x: display.size.width / 2, y: display.size.height / 2)
        pauseNode.size = CGSizeMake(display.size.height * 3, display.size.height * 2.5)
        pauseNode.name = "PauseButtonContainer"
        
        // Pause button
        pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.position = CGPoint(x: display.size.width / 2 , y: display.size.height / 2 - 25)
        pauseButton.size = CGSize(width: 100, height: 100)
        pauseButton.name = "PauseButton"
        pauseButton.zPosition = 1000
        
        // Health label
        healthLabel = SKLabelNode(fontNamed: "American Typewriter")
        healthLabel.position = CGPoint(x: 25, y: display.size.height / 2 - 25)
        health = 20
        healthLabel.text = "Health: \(health)"
        healthLabel.fontSize = display.size.height
        healthLabel.fontColor = SKColor.whiteColor()
        healthLabel.horizontalAlignmentMode = .Left
        healthLabel.zPosition = 15
        
        // Power Up Health Hearts
        powerUps = SKSpriteNode(imageNamed: "life_power_up_1")
        powerUps.position = CGPoint(x: 75, y: display.size.height / 2 - 75)
        powerUps.size = CGSize(width: 75, height: 75)
        powerUps.name = "PowerUp"
        powerUps.zPosition = 100
        
        // Label to let user know the count of power ups
        powerUpLabel = SKLabelNode(fontNamed: "American Typewriter")
        powerUpLabel.position = CGPoint(x: powerUps.frame.width + 115, y: display.size.height / 2 - 105)
        powerUpLabel.text = " X \(powerUpCount)"
        powerUpCount = 0
        powerUpLabel.fontSize = powerUps.size.height
        powerUpLabel.color = UIColor.redColor()
        powerUpLabel.colorBlendFactor = 1.0
        powerUpLabel.zPosition = 100
        
        // Score label
        scoreLabel = SKLabelNode(fontNamed: "American Typewriter")
        scoreLabel.position = CGPoint(x: display.size.width - 25, y: display.size.height / 2 - 25)
        scoreLabel.text = "Score: \(score)"
        score = 0
        scoreLabel.fontSize = display.size.height
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.zPosition = 15
        
        // Coin Image
        coinImage = SKSpriteNode(imageNamed: "Coin_1")
        coinImage.position = CGPoint(x: self.size.width - 225, y: display.size.height / 2 - 80)
        coinImage.size = CGSize(width: 75, height: 75)
        coinImage.name = "Coin"
        coinImage.zPosition = 200
        
        // Label to let user know the count of coins collected
        coinCountLbl = SKLabelNode(fontNamed: "American Typewriter")
        coinCountLbl.position = CGPoint(x: self.frame.width - 100, y: display.size.height / 2 - 105)
        coinCountLbl.text = " X \(coinCount)"
        coinCountLbl.fontSize = powerUps.size.height
        coinCount = 0
        coinCountLbl.color = UIColor.yellowColor()
        coinCountLbl.colorBlendFactor = 1.0
        coinCountLbl.zPosition = 200
        
        self.addChild(display)
        display.addChild(pauseNode)
        display.addChild(pauseButton)
        display.addChild(healthLabel)
        display.addChild(powerUps)
        display.addChild(powerUpLabel)
        display.addChild(scoreLabel)
        display.addChild(coinImage)
        display.addChild(coinCountLbl)
    }
    
    // Healthbar function for visual display
    func updateHealthBar(node: SKSpriteNode, withHealthPoints hp: Int) {
        
        let barSize = CGSize(width: healthBarWidth, height: healthBarHeight)
        
        let fillColor = UIColor(red: 113.0/255, green: 202.0/255, blue: 53.0/255, alpha:1)
        let borderColor = UIColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
        
        // Created drawing properties
        UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // Create the outline for the health bar
        borderColor.setStroke()
        let borderRect = CGRect(origin: CGPointZero, size: barSize)
        CGContextStrokeRectWithWidth(context, borderRect, 1)
        
        // Create the health bar with a colored rectangle
        fillColor.setFill()
        let barWidth = (barSize.width - 1) * CGFloat(hp) / CGFloat(maxHealth)
        let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
        CGContextFillRect(context, barRect)
        
        // Get the image
        let spriteImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Setup the sprite texture and size
        node.texture = SKTexture(image: spriteImage)
        node.size = barSize
    }

    // Check if the game is over by looking at our lives left
    func diedOnce() {
        
        self.gamePaused = true
        
        // Remove one life from hud
        if remainingLives > 1 {
            lifeNodes[remainingLives - 1].alpha = 0.0
            remainingLives -= 1
        }
        
        // check if remaining lifes exists
        if (remainingLives == 0) {
            showGameOverAlert()
        }
        
        // Stop movement, fade out, move to center, fade in
        player.removeAllActions()
        self.player.runAction(SKAction.fadeOutWithDuration(1) , completion: {
            self.player.position = CGPointMake(self.size.width/2, self.size.height/2)
            self.player.runAction(SKAction.fadeInWithDuration(1), completion: {
                self.gamePaused = false
            })
        })
    }
    
    // Displays the game over screen
    func showGameOverAlert() {
        self.gamePaused = true
        self.gameOver = true
        let alert = UIAlertController(title: "Game Over", message: "Score: \(score)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)  { _ in
            
        // Restore lifes in HUD
        remainingLives = 3
            for i in 1..<3 {
                lifeNodes[i].alpha = 1.0
            }
            
        // Reset score
        self.saveHighScore(self.score)
        self.score = 0
        self.scoreLabel.text = "\(0)"
        self.gamePaused = true
        })
    }
    
    // Saves all scores that are produced
    func saveHighScore(number: Int64) {
        
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "HIGH_SCORE")
            
            scoreReporter.value = Int64(number)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: nil)
        }
    }
    
//    func showGameOverScreen(){
//        gameOverLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
//        gameOverLabel!.text = "Game Over!  Score: \(score)"
//        gameOverLabel!.fontColor = SKColor.redColor()
//        gameOverLabel!.fontSize = 65
//        gameOverLabel!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
//        
//        gameOverLabel?.removeFromParent()
//        self.addChild(gameOverLabel!)
//        
////        restartScene()
//        createButton()
//    }
    
    // Function to restart
    func createButton() {
        
        restartButton = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 200, height: 100))
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartButton.zPosition = 160
        self.addChild(restartButton)
    }
    
    
    /********************************** Simulating Physics ***************************************/
    // MARK: - Simulate Physics
    
    override func didSimulatePhysics() {
        
    }
    
    
    /*********************************** Random Functions ****************************************/
    // MARK: - Simulate Physics
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func randomInRange(range: Range<Int>) -> Int {
        let count = UInt32(range.endIndex - range.startIndex)
        return  Int(arc4random_uniform(count)) + range.startIndex
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return random() * (max - min) + min
    }
    
    
    // MARK: - Analyse the collision/contact set up.
    func checkPhysics() {
        
        // Create an array of all the nodes with physicsBodies
        var physicsNodes = [SKNode]()
        
        //Get all physics bodies
        enumerateChildNodesWithName("//.") { node, _ in
            if let _ = node.physicsBody {
                physicsNodes.append(node)
            } else {
                print("\(node.name) does not have a physics body so cannot collide or be involved in contacts.")
            }
        }
        
        //For each node, check it's category against every other node's collion and contctTest bit mask
        for node in physicsNodes {
            let category = node.physicsBody!.categoryBitMask
            // Identify the node by its category if the name is blank
            let name = node.name != nil ? node.name : "Category \(category)"
            let collisionMask = node.physicsBody!.collisionBitMask
            let contactMask = node.physicsBody!.contactTestBitMask
            
            // If all bits of the collisonmask set, just say it collides with everything.
            if collisionMask == UInt32.max {
                print("\(name) collides with everything")
            }
            
            for otherNode in physicsNodes {
                if (node != otherNode) && (node.physicsBody?.dynamic == true) {
                    let otherCategory = otherNode.physicsBody!.categoryBitMask
                    // Identify the node by its category if the name is blank
                    let otherName = otherNode.name != nil ? otherNode.name : "Category \(otherCategory)"
                    
                    // If the collisonmask and category match, they will collide
                    if ((collisionMask & otherCategory) != 0) && (collisionMask != UInt32.max) {
                        print("\(name) collides with \(otherName)")
                    }
                    // If the contactMAsk and category match, they will contact
                    if (contactMask & otherCategory) != 0 {print("\(name) notifies when contacting \(otherName)")}
                }
            }
        }
    }
}
