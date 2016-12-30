//
//  GameScene.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/3/16.
//  Copyright (c) 2016 Full Sail. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit
import GameKit


// Protocol to inform the delegate GameVC if a game is over
protocol GameSceneDelegate {
    func showLeaderboard()
    func reportScore(_ score: Int64)
}

// Binary connections for collision and colliding
struct PhysicsCategory {
    static let GroundMask : UInt32 = 1    //0x1 << 0
    static let BulletMask : UInt32 = 2    //0x1 << 1
    static let PlayerMask : UInt32 = 4    //0x1 << 2
    static let EnemyMask  : UInt32 = 8    //0x1 << 3
    static let EnemyFire  : UInt32 = 16   //0x1 << 4
    static let PowerMask  : UInt32 = 32   //0x1 << 5
    static let BombMask   : UInt32 = 64   //0x1 << 6
    static let TurretMask : UInt32 = 128  //0x1 << 7
    static let SoldierMask: UInt32 = 256  //0x1 << 8
    static let MissileMask: UInt32 = 512  //0x1 << 9
    static let SkyBombMask: UInt32 = 1024 //0x1 << 10
    static let CoinMask   : UInt32 = 2048 //0x1 << 11
    static let All        : UInt32 = UInt32.max // all nodes
}

// HUD global variables
var lifeNodes: [SKSpriteNode] = []
var life = SKSpriteNode()
var remainingLives = 3

let darkenOpacity: CGFloat = 0.5
let darkenDuration: CFTimeInterval = 2


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Class delegates
    var gameCenterDelegate: GameSceneDelegate?    
    
    /************************** Property constants declared ************/
    // MARK: - Property constants declared
    
    // SK Physics body
    var firstBody = SKPhysicsBody()
    var secondBody = SKPhysicsBody()
    
    // Location for touch screen
    var touchLocation = CGPoint.zero
    
    // Emitter objects
    var smokeTrail = SKEmitterNode(fileNamed: "SmokeTrail")!
    var explode = SKEmitterNode(fileNamed: "Explode")!
    
    // Animation setup class
    let node = SKNode()
    var player = SKSpriteNode()
    var textureArray = [SKTexture]()
    
    // Enemy plane local properties
    var newEnemy = SKSpriteNode()
    var enemyPlaneArray = [SKSpriteNode]()
    
    // Enemy's weapon variables
    var enemyFire = SKSpriteNode()
    var missiles = SKSpriteNode()
    var turret = SKSpriteNode()
    var soldierWalk = SKSpriteNode()
    var soldierShoot = SKSpriteNode()
    var explosionTextures = [SKTexture]()
    
    // Player's weapons
    var bullet = SKSpriteNode()
    var bombs = SKSpriteNode()
    
    // Sky nodes
    var powerUps = SKSpriteNode()
    var coins = SKSpriteNode()
    var wingmenArray = [SKTexture]()
    var skyExplosion = SKSpriteNode()
    var randomAlly = SKSpriteNode()
    
    // Game metering GUI
    var died = Bool()
    var gamePaused = Bool()
    var gameStarted = Bool()
    var gameOver = Bool()
    
    // Labels and images
    var display = SKSpriteNode()
    var pauseNode = SKSpriteNode()
    var pauseButton = SKSpriteNode()
    var startButton = SKSpriteNode()
    var continueBTN = SKSpriteNode()
    var showLeader = SKSpriteNode()
    var coinImage = SKSpriteNode()
    var gameOverLabel = SKLabelNode()
    var levelTimerLabel = SKLabelNode()
    var timescore = Int()
    var timesecond = Int()
    
    // Setting incremental "score" labels and values
    var healthLabel = SKLabelNode()
    var health: Int = 0 {
        didSet {
            healthLabel.text = "Health: \(health)"
        }
    }
    
    var scoreLabel: SKLabelNode!
    var score: Int64 = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var powerUpLabel: SKLabelNode!
    var powerUpCount: Int = 0 {
        didSet {
            powerUpLabel.text = " X \(powerUpCount)"
        }
    }
    
    var coinCountLbl: SKLabelNode!
    var coinCount: Int = 0 {
        didSet {
            coinCountLbl.text = "X \(coinCount) "
        }
    }
    
    // Game Center Achievement properties
    var achievementIdentifier: String?
    var progressPercentage: Int64 = 0
    var progressInLevelAchievement: Bool?
    var levelAchievement: GKAchievement?
    var scoreAchievement: GKAchievement?
    var powerUpAchievement: GKAchievement?
    
    /********************************* Restart Scene funcs *********************************/
    // MARK: - Restart scenes
    
    // Function to restart scene
    func restartScene() {
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = true
        score = 0
        remainingLives = 4
        health = 20
        powerUpCount = 0
        coinCount = 0
        startScene()
    }
    
    // Starting scene, passed to didMoveToView
    func startScene() {
        
        // Sets the physics delegate and physics body
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self // Physics delegate set
        
        /**************************** Adding Scroll Background *****************************/
        // MARK: - Scroll Background
        
        // Adding scrolling Main Background
        createBackground()
        
        // Adding scrolling midground
        createMidground()
        
        // Adding scrolling foreground
        createForeground()
        
        // Call function to setup player's plane
        setupPlayer()
        
        // Tap to Start button
        startButton = SKSpriteNode(imageNamed: "start")
        startButton.zPosition = 1000
        startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        startButton.name = "StartButton"
        
        startButton.removeFromParent()
        self.addChild(startButton)
    }
    
    /******************************** didMoveToView Function ********************************/
    // MARK: - didMoveToView
    
    override func didMove(to view: SKView) {
        
        startScene()
    }
    
    
    /******************************** touchesBegan Function *********************************/
    // MARK: - touchesBegan
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if gameStarted == false {
            
            gameStarted = true
            
            // Remove button
            startButton.removeFromParent()
            
            /* function opens up the HUD and makes the button accessible
             also, has displays for health and score. */
            createHUD()
            
            /*********************************** Timers **************************************/
            // MARK: - Spawn Timers
            
            // Spawning wingman timer call
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run(spawnWingman),
                SKAction.wait(forDuration: 12)
                ])
                ))
            
            // Spawning power up timer call
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run(spawnPowerUps),
                SKAction.wait(forDuration: 120)
                ])
                ))
            
            // Spawning enemy planes
            let xSpawn = randomBetweenNumbers(2.0, secondNum: 8.0)
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run(spawnEnemyPlanes),
                SKAction.wait(forDuration: TimeInterval(xSpawn))
                ])
                ))
            
            // Sky bomb spawn timer
            let xSpawn2 = randomBetweenNumbers(10.0, secondNum: 20.0)
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run(skyExplosions),
                SKAction.wait(forDuration: TimeInterval(xSpawn2))
                ])
                ))
            
            // Soldier timer
            let xSpawn3 = randomBetweenNumbers(2.0, secondNum: 10.0)
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run(setupSoldiers),
                SKAction.wait(forDuration: TimeInterval(xSpawn3))
                ])
                ))
            
            // Shooting soldiers spawn timer
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run(setupShooters),
                SKAction.wait(forDuration: 20)
                ])
                ))
            
            // Turret spawn timer
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run(setupTurret),
                SKAction.wait(forDuration: 30)
                ])
                ))
            
            // Turret missile spawn timer
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run(spawnTurretMissiles),
                SKAction.wait(forDuration: 5.0)
                ])
                ))
            
            // Coin spawn timer
            let xSpawn4 = randomBetweenNumbers(10.0, secondNum: 20.0)
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run(spawnCoins),
                SKAction.wait(forDuration: TimeInterval(xSpawn4))
                ])
                ))
            
            
            // Game Time functions
            let actionwait = SKAction.wait(forDuration: 1.0)
            let actionrun = SKAction.run({
                self.timescore += 1
                self.timesecond += 1
                if self.timesecond == 60 {self.timesecond = 0}
                self.levelTimerLabel.text = "Time: \(self.timescore/60):\(self.timesecond)"
            })
            levelTimerLabel.run(SKAction.repeatForever(SKAction.sequence([actionwait,actionrun])))
        }
        
        // Call function when play sound
        self.run(SKAction.playSoundFileNamed("startGame", waitForCompletion: false))
        
        touchLocation = touches.first!.location(in: self)
        
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).location(in: self)
            
            let node = self.atPoint(location)
            
            if (node.name == "PauseButton") {
                showPauseAlert()
            }
            
            if (node.name == "Continue") {
                startScene()
                gameStarted = true
                playGame()
                continueBTN.removeFromParent()
                startButton.removeFromParent()
            }
            
            /* Allows to tap on screen and plane will present
             at that axis and shoot at point touched */
            player.position.y = location.y // Allows a tap to touch on the y axis
            player.position.x = location.x // Allows a tap to touch on the x axis
            
            // Double tap screen to drop bomb
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(fireBombs))
            self.view!.addGestureRecognizer(tapRecognizer)
            tapRecognizer.numberOfTapsRequired = 2
        }
    }
    
    
    /********************************* touchesMoved Function **************************************/
    // MARK: - touchesMoved
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchLocation = touches.first!.location(in: self)
        
        for touch: AnyObject in touches {
            let location = (touch as! UITouch).location(in: self)
            
            /* Allows to drag on screen and plane will follow
            that axis and shoot at point when released */
            player.position.y = location.y // Allows a tap to touch on the y axis
            player.position.x = location.x
            
            fireBullets()
        }
    }
    
    
    /************************************ didBeginContact *****************************************/
    // MARK: - didBeginContact
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if !self.gamePaused && !self.gameOver {
            
            // beginContact constants
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            
            if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
                
                firstBody = contact.bodyA
                secondBody = contact.bodyB
                
            } else {
                
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            
            // Contact statements
            if ((firstBody.categoryBitMask & PhysicsCategory.BulletMask != 0) && (secondBody.categoryBitMask & PhysicsCategory.EnemyMask != 0)) {
                secondBody.node!.removeFromParent()
                enemyExplosion(secondBody.node!)
                score += 1
            }
                
            else if ((firstBody.categoryBitMask & PhysicsCategory.GroundMask != 0) && (secondBody.categoryBitMask & PhysicsCategory.PlayerMask != 0)) {
                enemyExplosion(secondBody.node!)
                secondBody.node!.removeFromParent()
                smokeTrail.removeFromParent()
                bullet.removeFromParent()
                health = 0
                diedOnce()
            }
                
            else if ((firstBody.categoryBitMask & PhysicsCategory.BombMask != 0) && (secondBody.categoryBitMask & PhysicsCategory.TurretMask != 0)) {
                enemyExplosion(secondBody.node!)
                secondBody.node!.removeFromParent()
                bothNodesGone()
                score += 2
            }
                
            else if ((firstBody.categoryBitMask & PhysicsCategory.BombMask != 0) && (secondBody.categoryBitMask & PhysicsCategory.GroundMask != 0)) {
                enemyExplosion(firstBody.node!)
                firstBody.node!.removeFromParent()
                crashSound()
            }
                
            else if ((firstBody.categoryBitMask & PhysicsCategory.PlayerMask != 0) && (secondBody.categoryBitMask & PhysicsCategory.EnemyMask != 0)) {
                enemyExplosion(firstBody.node!)
                enemyExplosion(secondBody.node!)
                smokeTrail.removeFromParent()
                bullet.removeFromParent()
                bothNodesGone()
                diedOnce()
            }
                
            else if ((firstBody.categoryBitMask & PhysicsCategory.PlayerMask != 0) && (secondBody.categoryBitMask & PhysicsCategory.EnemyFire != 0)) {
                sparks(firstBody.node!.position)
                self.run(SKAction.playSoundFileNamed("ricochet", waitForCompletion: false))
                health -= 1
            }
                
            else if ((firstBody.categoryBitMask & PhysicsCategory.PlayerMask != 0) && (secondBody.categoryBitMask & PhysicsCategory.PowerMask != 0)) {
                sparks(secondBody.node!.position)
                secondBody.node!.removeFromParent()
                self.run(SKAction.playSoundFileNamed("taDa", waitForCompletion: false))
                health += 20
                powerUpCount += 1
            }
                
            else if ((firstBody.categoryBitMask & PhysicsCategory.SkyBombMask != 0) && (secondBody.categoryBitMask & PhysicsCategory.EnemyMask != 0)) {
                oneNodeGone()
            }
                
            else if ((firstBody.categoryBitMask & PhysicsCategory.PlayerMask != 0) && (secondBody.categoryBitMask & PhysicsCategory.MissileMask != 0)) {
                bothNodesGone()
                health -= 5
            }            else if ((firstBody.categoryBitMask & PhysicsCategory.PlayerMask != 0) && (secondBody.categoryBitMask & PhysicsCategory.CoinMask != 0)) {
                sparks(secondBody.node!.position)
                secondBody.node!.removeFromParent()
                self.run(SKAction.playSoundFileNamed("coin", waitForCompletion: false))
                coinCount += 1
            }
                
            else if ((firstBody.categoryBitMask & PhysicsCategory.BulletMask != 0) && (secondBody.categoryBitMask & PhysicsCategory.CoinMask != 0)) {
                sparks(secondBody.node!.position)
                secondBody.node!.removeFromParent()
                self.run(SKAction.playSoundFileNamed("coin", waitForCompletion: false))
                coinCount += 1
            }
        }
    }
    
    // Following functions are to minimize repeated code for contacts
    func bothNodesGone() {
        enemyExplosion(secondBody.node!)
        removeBothNodes()
    }
    
    func oneNodeGone() {
        enemyExplosion(secondBody.node!)
        secondBody.node!.removeFromParent()
    }
    
    // Remove both nodes
    func removeBothNodes() {
        firstBody.node!.removeFromParent()
        secondBody.node!.removeFromParent()
    }

    
    /*********************************** Update Function *****************************************/
    // MARK: - Update Function
    
    // Update for animations and positions
    override func update(_ currentTime: TimeInterval) {
        
        if !self.gamePaused && !self.gameOver {
        
            // Move backgrounds
            moveBackground()
            moveMidground()
            moveForeground()
            
            // Plane's smoketrail will follow it as updating occurs
            smokeTrail.position = CGPoint(x: player.position.x - 80, y: player.position.y - 10)
            smokeTrail.zPosition = 100
            smokeTrail.targetNode = self
            smokeTrail.removeFromParent()
            addChild(smokeTrail)
            
            // Changes health label red if too low
            if health >= 10 {
                healthLabel.fontColor = SKColor.green
            }
            else {
                healthLabel.fontColor = SKColor.red
            }
            
            // check if remaining lifes exists
            if remainingLives == 0 || score >= Int64(200) {
                showGameOverAlert()
            }
        }
    }
    
    
    /********************************* Background Functions *********************************/
    // MARK: - Background Functions
    
    // Adding scrolling background
    func createBackground() {
        
        let myBackground = SKTexture(imageNamed: "cartoonCloudsBGLS")
        
        for i in 0...1 {
            let background = SKSpriteNode(texture: myBackground)
            background.name = "Background"
            background.zPosition = 0
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: (myBackground.size().width * CGFloat(i)) - CGFloat(1 * i), y: 0)
            
            background.removeFromParent()
            self.addChild(background)
        }
    }
    
    // Puts createMyBackground in motion
    func moveBackground() {
        
        self.enumerateChildNodes(withName: "Background", using: ({
            (node, error) in
            
            node.position.x -= 1.0
            
            if node.position.x < -((self.scene?.size.width)!) {
                
                node.position.x += (self.scene?.size.width)!
            }
        }))
    }
    
    // Adding scrolling midground
    func createMidground() {
        
        let midground = SKTexture(imageNamed: "mountains")
        
        for i in 0...2 {
            let ground = SKSpriteNode(texture: midground)
            ground.name = "Midground"
            ground.zPosition = 20
            ground.position = CGPoint(x: (midground.size().width / 2.0 + (midground.size().width * CGFloat(i))), y: midground.size().height / 2)
            
            ground.removeFromParent()
            self.addChild(ground)
        }
    }
    
    // Puts createMyMidground in motion
    func moveMidground() {
        
        self.enumerateChildNodes(withName: "Midground", using: ({
            (node, error) in
            
            node.position.x -= 2.0
            
            if node.position.x < -((self.scene?.size.width)!) {
                
                node.position.x += (self.scene?.size.width)! * 2
            }
        }))
    }
    
    // Adding scrolling foreground
    func createForeground() {
        
        let foreground = SKTexture(imageNamed: "lonelytree")
        
        for i in 0...6 {
            let ground = SKSpriteNode(texture: foreground)
            ground.name = "Foreground"
            ground.zPosition = 30
            ground.position = CGPoint(x: (foreground.size().width / 2.0 + (foreground.size().width * CGFloat(i))), y: foreground.size().height / 2)
            
            ground.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "lonelytree.png"), size: ground.size)
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.categoryBitMask = PhysicsCategory.GroundMask
            ground.physicsBody?.contactTestBitMask = PhysicsCategory.BombMask | PhysicsCategory.PlayerMask
            ground.physicsBody?.collisionBitMask = PhysicsCategory.BombMask | PhysicsCategory.PlayerMask
            
            ground.removeFromParent()
            self.addChild(ground)
        }
    }
    
    // Puts createMyForeground in motion
    func moveForeground() {
        
        self.enumerateChildNodes(withName: "Foreground", using: ({
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
        
        player = SKScene(fileNamed: "Player")!.childNode(withName: "player")! as! SKSpriteNode
        
        player.position = CGPoint(x: self.size.width / 6, y: self.size.height / 2)
        player.name = "Player"
        player.setScale(0.8)
        player.zPosition = 100

        // Body physics for player's planes
        player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "MyFokker2.png"), size: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.PlayerMask
        player.physicsBody?.contactTestBitMask = PhysicsCategory.PowerMask | PhysicsCategory.EnemyFire |
            PhysicsCategory.EnemyMask | PhysicsCategory.MissileMask | PhysicsCategory.SkyBombMask | PhysicsCategory.CoinMask
        player.physicsBody?.collisionBitMask = PhysicsCategory.PowerMask
        
        player.removeFromParent()
        self.addChild(player) // Add our player to the scene
        
        self.run(SKAction.playSoundFileNamed("biplaneFlying", waitForCompletion: true))
    }
    
    /************************************ Spawn Player's Weapons *****************************************/
    // MARK: - Spawn Player's Weapons
    
    // Create the ammo for our plane to fire
    func fireBullets() {
        
        bullet = SKSpriteNode(imageNamed: "fireBullet")
        
        bullet.position = CGPoint(x: player.position.x + 70, y: player.position.y + 20)
        bullet.name = "FireBullets"
        bullet.setScale(0.8)
        bullet.zPosition = 100
        
        // Body physics for plane's bulets
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.allowsRotation = false
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.BulletMask
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.EnemyMask | PhysicsCategory.PowerMask | PhysicsCategory.CoinMask
        bullet.physicsBody?.collisionBitMask = 0
        
        self.addChild(bullet) // Add bullet to the scene
        
        // Shoot em up!
        let action = SKAction.moveTo(x: self.size.width + 150, duration: 2.0)
        let actionDone = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([action, actionDone]))
        
        // Add gun sound
        self.run(SKAction.playSoundFileNamed("shoot", waitForCompletion: false))
    }
    
    // Create the bombs for our plane to drop
    func fireBombs() {
        
        bombs = SKSpriteNode(imageNamed: "bomb")
        
        bombs.position = CGPoint(x: player.position.x, y: player.position.y)
        bombs.name = "Bombs"
        bombs.setScale(0.1)
        bombs.zPosition = 105
        
        // Body physics for plane's bombs
        bombs.physicsBody = SKPhysicsBody(rectangleOf: bombs.size)
        bombs.physicsBody?.isDynamic = true
        bombs.physicsBody?.usesPreciseCollisionDetection = true
        bombs.physicsBody?.categoryBitMask = PhysicsCategory.BombMask
        bombs.physicsBody?.contactTestBitMask = PhysicsCategory.TurretMask | PhysicsCategory.SoldierMask | PhysicsCategory.EnemyMask | PhysicsCategory.GroundMask | PhysicsCategory.MissileMask
        bombs.physicsBody?.collisionBitMask = 0
        
        bombs.removeFromParent()
        self.addChild(bombs) // Add bombs to the scene
        
        let moveBombAction = SKAction.moveTo(y: -100, duration: 2.0)
        let removeBombAction = SKAction.removeFromParent()
        bombs.run(SKAction.sequence([moveBombAction,removeBombAction]))
        
        // Add gun sound
        self.run(SKAction.playSoundFileNamed("bombaway", waitForCompletion: true))
    }
    
    /********************************* Spawn Our Sky Nodes **************************************/
    // MARK: - Spawn good sky nodes
    
    // Adding ally forces in background
    func spawnWingman() {
        
        let allyAtlas = SKTextureAtlas(named: "AllyPlanes")
        
        // Wingmen passby's in the distance
        for i in 1...allyAtlas.textureNames.count {
            let ally = "wingman\(i).png"
            
            wingmenArray.append(SKTexture(imageNamed: ally))
        }
        
        // Generate a random index
        let randomIndex = Int(arc4random_uniform(UInt32(wingmenArray.count)))
        
        // Get a random ally
        randomAlly = SKSpriteNode(texture: wingmenArray[randomIndex])
        randomAlly.name = "Ally"
        randomAlly.zPosition = 22
        randomAlly.setScale(0.3)
        
        // Calculate random spawn points for wingmen
        let random = CGFloat(arc4random_uniform(700) + 250)
        randomAlly.position = CGPoint(x: -self.size.width, y: random)
        
        // Body physics for plane's bombs
        randomAlly.physicsBody = SKPhysicsBody(rectangleOf: randomAlly.frame.size)
        randomAlly.physicsBody?.isDynamic = false
        randomAlly.physicsBody?.categoryBitMask = PhysicsCategory.PlayerMask
        randomAlly.physicsBody?.contactTestBitMask = PhysicsCategory.SkyBombMask
        randomAlly.physicsBody?.collisionBitMask = 0
        
        randomAlly.removeFromParent()
        addChild(randomAlly) // Generate the random wingman
        
        // Move enemies forward with random intervals
        let wingmanDuration = randomBetweenNumbers(12.0, secondNum: 24.0)
        
        // SKAction for the spritenode itself...to move forward
        let action = SKAction.moveTo(x: self.size.width + 80, duration: TimeInterval(wingmanDuration))
        let actionDone = SKAction.removeFromParent()
        randomAlly.run(SKAction.sequence([action, actionDone]))
    }
    
    // Spawning a bonus star
    func spawnPowerUps() {
        
        // Add user's animated powerUp
        powerUps = SKScene(fileNamed: "PowerUps")!.childNode(withName: "powerUp")! as! SKSpriteNode
        
        // Star position off screen
        let xPos = randomBetweenNumbers(0, secondNum: self.frame.width )
        let randomY = CGFloat(arc4random_uniform(650) + 250)
        
        // Sky bomb position on screen
        powerUps.position = CGPoint(x: xPos, y: randomY)
        powerUps.name = "PowerUps"
        powerUps.setScale(1.0)
        powerUps.zPosition = 100
        
        // Body physics for power ups
        powerUps.physicsBody = SKPhysicsBody(texture: powerUps.texture!, size: powerUps.size)
        powerUps.physicsBody?.isDynamic = true
        powerUps.physicsBody?.allowsRotation = false
        powerUps.physicsBody?.categoryBitMask = PhysicsCategory.PowerMask
        powerUps.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerMask | PhysicsCategory.BulletMask
        powerUps.physicsBody?.collisionBitMask = PhysicsCategory.PlayerMask | PhysicsCategory.BulletMask
        
        powerUps.removeFromParent()
        addChild(powerUps) // Add power ups to the scene
        
        // Add PowerUp sound
        self.run(SKAction.playSoundFileNamed("powerUp", waitForCompletion: false) )
    }
    
    // Spawning coins
    func spawnCoins() {
        
        // Add user's animated powerUp
        coins = SKScene(fileNamed: "Coins")!.childNode(withName: "coins")! as! SKSpriteNode
        
        let xPos = randomBetweenNumbers(0, secondNum: self.frame.width )
        let randomY = CGFloat(arc4random_uniform(650) + 250)
        
        // Star position on screen
        coins.position = CGPoint(x: xPos, y: randomY)
        coins.name = "Coins"
        coins.setScale(1.0)
        coins.zPosition = 100
        
        // Body physics for coins
        coins.physicsBody = SKPhysicsBody(circleOfRadius: size.height / 2)
        coins.physicsBody?.isDynamic = true
        coins.physicsBody?.allowsRotation = false
        coins.physicsBody?.categoryBitMask = PhysicsCategory.CoinMask
        coins.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerMask | PhysicsCategory.BulletMask
        coins.physicsBody?.collisionBitMask = 0
        
        coins.removeFromParent()
        addChild(coins) // Add coins to the scene
        
        // Add PowerUp sound
        self.run(SKAction.playSoundFileNamed("coin", waitForCompletion: false) )
    }
    
    // Spawn sky nodes
    func skyExplosions() {
        
        let enemyDeathAtlas = SKTextureAtlas(named: "EnemyDeath")
        let textureNames = enemyDeathAtlas.textureNames
        var explosionTextures = [SKTexture]()
        for name: String in textureNames {
            let texture = enemyDeathAtlas.textureNamed(name)
            explosionTextures.append(texture)
        }
        
        // Add explosion
        skyExplosion = SKSpriteNode(texture: explosionTextures[0])
        skyExplosion.name = "Explosion"
        skyExplosion.zPosition = 100
        skyExplosion.setScale(0.5)
        
        // Random Coordinates
        let xPos = randomBetweenNumbers(0, secondNum: self.frame.width )
        let randomY = CGFloat(arc4random_uniform(700) + 50)
        
        // Sky bomb position on screen
        skyExplosion.position = CGPoint(x: xPos, y: randomY)
        
        // Body physics for plane's bombs
        skyExplosion.physicsBody = SKPhysicsBody(circleOfRadius: size.height/2)
        skyExplosion.physicsBody?.isDynamic = true
        skyExplosion.physicsBody?.categoryBitMask = PhysicsCategory.SkyBombMask
        skyExplosion.physicsBody?.contactTestBitMask = PhysicsCategory.EnemyMask
        skyExplosion.physicsBody?.collisionBitMask = PhysicsCategory.PlayerMask
        
        skyExplosion.removeFromParent()
        addChild(skyExplosion) // Add sky bomb to the scene
        
        // Animation SKAction
        let action = SKAction.animate(with: explosionTextures, timePerFrame: 0.07)
        let actionDone = SKAction.removeFromParent()
        skyExplosion.run(SKAction.sequence([action, actionDone]))
        
        // Add sky explosion sound
        self.run(SKAction.playSoundFileNamed("skyBoom", waitForCompletion: false) )
    }

    /********************************** Spawn Enemy Planes ***************************************/
    // MARK: - Spawn Enemy Planes
    
    // Generate enemy fighter planes
    func spawnEnemyPlanes() {
        
        let enemy1 = SKScene(fileNamed: "Enemy1")!.childNode(withName: "enemy1")! as! SKSpriteNode
        let enemy2 = SKScene(fileNamed: "Enemy2")!.childNode(withName: "enemy2")! as! SKSpriteNode
        let enemy3 = SKScene(fileNamed: "Enemy3")!.childNode(withName: "enemy3")! as! SKSpriteNode
        let enemy4 = SKScene(fileNamed: "Enemy4")!.childNode(withName: "enemy4")! as! SKSpriteNode
        
        enemyPlaneArray = [enemy1, enemy2, enemy3, enemy4]
        
        // Generate a random index
        let randomIndex = Int(arc4random_uniform(UInt32(enemyPlaneArray.count)))
        
        // Get a random enemy
        newEnemy = (enemyPlaneArray[randomIndex])
        newEnemy.name = "EnemyPlanes"
        newEnemy.setScale(0.25)
        newEnemy.zPosition = 100
        
        // Calculate random spawn points for air enemies
        let randomY = CGFloat(arc4random_uniform(650) + 350)
        newEnemy.position = CGPoint(x: self.size.width, y: randomY)
        
        // Added randomEnemy's physics
        newEnemy.physicsBody = SKPhysicsBody(texture: newEnemy.texture!, size: newEnemy.size)
        newEnemy.physicsBody?.isDynamic = true
        newEnemy.physicsBody?.allowsRotation = false
        newEnemy.physicsBody?.categoryBitMask = PhysicsCategory.EnemyMask
        newEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.BulletMask | PhysicsCategory.BombMask | PhysicsCategory.SkyBombMask
        newEnemy.physicsBody?.collisionBitMask = 0
        
        newEnemy.removeFromParent()
        addChild(newEnemy) // Add enemies
        
        // Move enemies forward with random intervals
        let actualDuration = CGFloat.random(min: 3, max: 6)
        
        // Create a path func for planes to randomly follow {
        let actionMove = SKAction.move(to: CGPoint(x: -newEnemy.size.width / 2, y: randomY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        newEnemy.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        spawnEnemyFire()
    }
    
    /************************************ Spawn Enemy Weapons *****************************************/
    // MARK: - Spawn Enemy Weapons
    
    // Function to allow all enemy planes to get setup and fire
    func spawnEnemyFire() {
        
        enemyFire = SKScene(fileNamed: "EnemyFire")!.childNode(withName: "bullet")! as! SKSpriteNode
        
        // Positioning enemyFire to randomEnemy group
        enemyFire.position = CGPoint(x: newEnemy.position.x - 100, y: newEnemy.position.y)
        
        enemyFire.name = "EnemyFire"
        enemyFire.color = UIColor.yellow
        enemyFire.setScale(0.2)
        enemyFire.zPosition = 100
        
        enemyFire.removeFromParent()
        addChild(enemyFire) // Generate enemy fire
        
        // Added enemy's fire physics
        enemyFire.physicsBody = SKPhysicsBody(rectangleOf: enemyFire.size)
        enemyFire.physicsBody?.isDynamic = true
        enemyFire.physicsBody?.allowsRotation = false
        enemyFire.physicsBody?.categoryBitMask = PhysicsCategory.EnemyFire
        enemyFire.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerMask
        enemyFire.physicsBody?.collisionBitMask = 0
        
        // Shoot em up!
        let action = SKAction.moveTo(x: -50, duration: 1.5)
        let actionDone = SKAction.removeFromParent()
        enemyFire.run(SKAction.sequence([action, actionDone]))
    }
    
    // Setup turret to be able to shoot missiles
    func setupTurret() {
        
        // Setup shooting turret
        turret = SKScene(fileNamed: "Turrets")!.childNode(withName: "turret")! as! SKSpriteNode
        
        // Attempt to keep turret looking stationary
        turret.position = CGPoint(x: self.size.width, y: 240)
        turret.name = "Turret"
        turret.zPosition = 100
        
        // Added turret's physics
        turret.physicsBody = SKPhysicsBody(texture: turret.texture!, size: turret.size)
        turret.physicsBody?.isDynamic = false
        turret.physicsBody?.categoryBitMask = PhysicsCategory.TurretMask
        turret.physicsBody?.contactTestBitMask = PhysicsCategory.BombMask
        turret.physicsBody?.collisionBitMask = PhysicsCategory.BombMask
        
        turret.removeFromParent()
        addChild(turret) // Add turret to scene
        
        // Add turret and fire
        let action = SKAction.move(to: CGPoint(x: -100, y: 230), duration: 45)
        let actionDone = SKAction.removeFromParent()
        turret.run(SKAction.sequence([action, actionDone]))
    }
    
    // Spawn enemy tank missiles
    func spawnTurretMissiles() {
        
        // Spawning an enemy tank's anti-aircraft missiles
        missiles = SKScene(fileNamed: "Missiles")!.childNode(withName: "turretMissile")! as! SKSpriteNode
        missiles.name = "TurretMissiles"
        missiles.setScale(0.5)
        missiles.zPosition = 100
        missiles.zRotation = 0.506
        
        missiles.position = CGPoint(x: turret.position.x - 30, y: turret.position.y + 20)
        
        // Added turret's missile physics
        missiles.physicsBody = SKPhysicsBody(rectangleOf: missiles.frame.size)
        missiles.physicsBody?.isDynamic = true
        missiles.physicsBody?.allowsRotation = false
        missiles.physicsBody?.usesPreciseCollisionDetection = true
        missiles.physicsBody?.categoryBitMask = PhysicsCategory.MissileMask
        missiles.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerMask | PhysicsCategory.BulletMask
        missiles.physicsBody?.collisionBitMask = 0
        
        missiles.removeFromParent()
        addChild(missiles) // Generate tank missile
        
        // Shoot em up!
        let action = SKAction.move(to: CGPoint(x: -50, y: self.size.height + 80), duration: 3.0)
        let actionDone = SKAction.removeFromParent()
        missiles.run(SKAction.sequence([action, actionDone]))
    }
    
    // Spawning a walking soldier
    func setupSoldiers() {
        
        // Allows for random y axis spawning
        let yPos = randomBetweenNumbers(100, secondNum: 225)
        
        // Add user's animated walking soldiers
        soldierWalk = SKScene(fileNamed: "SoldierWalk")!.childNode(withName: "soldierWalk")! as! SKSpriteNode
        
        // Sky bomb position on screen
        soldierWalk.position = CGPoint(x: self.frame.width, y: yPos)
        soldierWalk.name = "Soldiers"
        soldierWalk.zPosition = 102
        
        // Added soldier's physics
        soldierWalk.physicsBody = SKPhysicsBody(texture: soldierWalk.texture!, size: soldierWalk.size)
        soldierWalk.physicsBody?.isDynamic = true
        soldierWalk.physicsBody?.allowsRotation = false
        soldierWalk.physicsBody?.categoryBitMask = PhysicsCategory.SoldierMask
        soldierWalk.physicsBody?.contactTestBitMask = PhysicsCategory.BombMask
        soldierWalk.physicsBody?.collisionBitMask = 0
        
        soldierWalk.removeFromParent()
        addChild(soldierWalk)
        
        // Move soldiers forward
        let walkAcrossScreen = SKAction.move(to: CGPoint(x: -40, y: yPos), duration: 20)
        let actionDone = SKAction.removeFromParent()
        soldierWalk.run(SKAction.sequence([walkAcrossScreen, actionDone]))
    }
    
    // Spawning a shooting soldier
    func setupShooters() {
        
        // Add user's animated walking soldiers
        soldierShoot = SKScene(fileNamed: "SoldierShoot")!.childNode(withName: "soldierShoot")! as! SKSpriteNode
        
        // Sky bomb position on screen
        soldierShoot.position = CGPoint(x: self.frame.width, y: 155)
        soldierShoot.name = "Shooters"
        soldierShoot.zPosition = 101
        
        // Added shooter's physics
        soldierShoot.physicsBody = SKPhysicsBody(texture: soldierShoot.texture!, size: soldierShoot.size)
        soldierShoot.physicsBody?.isDynamic = true
        soldierShoot.physicsBody?.allowsRotation = false
        soldierShoot.physicsBody?.categoryBitMask = PhysicsCategory.SoldierMask
        soldierShoot.physicsBody?.contactTestBitMask = PhysicsCategory.BombMask
        soldierShoot.physicsBody?.collisionBitMask = 0
        
        soldierShoot.removeFromParent()
        addChild(soldierShoot) // Add shooting soldiers to the scene
        
        // Move soldiers forward
        let shootPlanes = SKAction.move(to: CGPoint(x: -40, y: 185), duration: 35)
        let actionRepeat = SKAction.removeFromParent()
        soldierShoot.run(SKAction.sequence([shootPlanes, actionRepeat]))
    }
    
    // Create explosions
    func enemyExplosion(_ plane: SKNode) {
        let enemyDeathAtlas = SKTextureAtlas(named: "EnemyDeath")
        let textureNames = enemyDeathAtlas.textureNames
        self.explosionTextures = [SKTexture]()
        for name: String in textureNames {
            let texture = enemyDeathAtlas.textureNamed(name)
            explosionTextures.append(texture)
        }
        
        //add explosion
        let explosion = SKSpriteNode(texture: explosionTextures[0])
        explosion.zPosition = 151
        explosion.position = (plane.position)
        
        explosion.removeFromParent()
        self.addChild(explosion)
        
        // Animation action
        let action = SKAction.animate(with: explosionTextures, timePerFrame: 0.07)
        let actionDone = SKAction.removeFromParent()
        explosion.run(SKAction.sequence([action, actionDone]))
        
        crashSound()
    }
    
    /******************************** Emitter Node Functions ************************************/
    // MARK: - Emitter Node Functions
    
    func fire(_ pos: CGPoint) {
        let emitterNode = SKEmitterNode(fileNamed: "FireExplosion.sks")
        emitterNode!.position = pos
        self.addChild(emitterNode!)
        self.run(SKAction.wait(forDuration: 2), completion: { emitterNode!.removeFromParent() })
    }

    func sparks(_ pos: CGPoint) {
        let emitterNode = SKEmitterNode(fileNamed: "Explode.sks")
        emitterNode!.position = pos
        self.addChild(emitterNode!)
        self.run(SKAction.wait(forDuration: 2), completion: { emitterNode!.removeFromParent() })
    }

    // Add crashing sound method
    func crashSound() {
        self.run(SKAction.playSoundFileNamed("crash", waitForCompletion: false))
    }

    
    /*************************************** HUD & Buttons ************************************/
    // Heads Up Display
    
    // Function to restart & play scene again
    func continueButton() {
        
        continueBTN = SKSpriteNode(imageNamed: "continue")
        continueBTN.size = CGSize(width: 200, height: 100)
        continueBTN.name = "Continue"
        continueBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        continueBTN.zPosition = 1000
        continueBTN.setScale(0)
        continueBTN.removeFromParent()
        addChild(continueBTN)
        continueBTN.run(SKAction.scale(to: 1.0, duration: 0.4))
    }
    
    // Heads Up Display attributes
    func createHUD() {
        
        // Adding HUD with pause
        display = SKSpriteNode(color: UIColor.black, size: CGSize(width: self.size.width, height: self.size.height * 0.06))
        display.anchorPoint = CGPoint(x: 0, y: 0)
        display.position = CGPoint(x: 0, y: self.size.height - display.size.height)
        display.zPosition = 200
        
        // Amount of lives
        let lifeSize = CGSize(width: display.size.height-10, height: display.size.height-10)
        
        for i in 0..<remainingLives {
            
            let life = SKSpriteNode(imageNamed: "life")
            life.position=CGPoint(x: life.size.width * 0.5 * (1.0 + CGFloat(i)), y: display.size.height / 2)
            lifeNodes.append(life)
            life.size = lifeSize
            life.zPosition = 175
            display.addChild(life)
        }
        
        // Pause button
        pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.position = CGPoint(x: display.size.width / 2 , y: display.size.height / 2 - 15)
        pauseButton.size = CGSize(width: 100, height: 100)
        pauseButton.name = "PauseButton"
        pauseButton.zPosition = 1000
        
        // Health label
        healthLabel = SKLabelNode(fontNamed: "American Typewriter")
        healthLabel.position = CGPoint(x: display.size.width * 0.25, y: display.size.height / 2 - 25)
        healthLabel.text = "Health: 20"
        healthLabel.fontSize = display.size.height
        healthLabel.fontColor = SKColor.white
        healthLabel.horizontalAlignmentMode = .left
        healthLabel.zPosition = 15
        
        // Power Up Health Hearts
        powerUps = SKSpriteNode(imageNamed: "life_power_up_1")
        powerUps.position = CGPoint(x: 75, y: display.size.height / 2 - 75)
        powerUps.size = CGSize(width: 75, height: 75)
        powerUps.name = "PowerUp"
        powerUps.zPosition = 100
        
        // Label to let user know the count of power ups
        powerUpLabel = SKLabelNode(fontNamed: "American Typewriter")
        powerUpLabel.position = CGPoint(x: powerUps.frame.width + 125, y: display.size.height / 2 - 105)
        powerUpLabel.text = "X 0"
        powerUpLabel.fontSize = powerUps.size.height
        powerUpLabel.fontColor = SKColor.red
        powerUpLabel.colorBlendFactor = 1.0
        powerUpLabel.zPosition = 100
        
        // Game level timer
        levelTimerLabel = SKLabelNode(fontNamed: "American Typewriter")
        levelTimerLabel.position = CGPoint(x: display.size.width * 0.7 - 20, y: display.size.height / 2 - 25)
        levelTimerLabel.fontSize = display.size.height
        levelTimerLabel.fontColor = SKColor.white
        levelTimerLabel.zPosition = 1001
        
        // Score label
        scoreLabel = SKLabelNode(fontNamed: "American Typewriter")
        scoreLabel.position = CGPoint(x: display.size.width - 25, y: display.size.height / 2 - 25)
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = display.size.height
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.zPosition = 15
        
        // Coin Image
        coinImage = SKSpriteNode(imageNamed: "Coin_1")
        coinImage.position = CGPoint(x: self.size.width - 245, y: display.size.height / 2 - 80)
        coinImage.size = CGSize(width: 75, height: 75)
        coinImage.name = "Coin"
        coinImage.zPosition = 200
        
        // Label to let user know the count of coins collected
        coinCountLbl = SKLabelNode(fontNamed: "American Typewriter")
        coinCountLbl.position = CGPoint(x: self.frame.width - 105, y: display.size.height / 2 - 105)
        coinCountLbl.text = "X 0 "
        coinCountLbl.fontSize = powerUps.size.height
        coinCountLbl.fontColor = SKColor.brown
        coinCountLbl.zPosition = 200
        
        self.addChild(display)
        display.addChild(pauseButton)
        display.addChild(healthLabel)
        display.addChild(powerUps)
        display.addChild(powerUpLabel)
        display.addChild(levelTimerLabel)
        display.addChild(scoreLabel)
        display.addChild(coinImage)
        display.addChild(coinCountLbl)
    }
    

    /*************************************** GUI ******************************************/
    // Show Pause Alert
    
    // Pause and Play functions - handles NSTimers as well
    func pauseGame(){
        scene?.view?.isPaused = true
    }
    
    func playGame(){
        scene?.view?.isPaused = false
    }
    
    // Show Pause Alert
    func showPauseAlert() {
        pauseGame()
        let alert = UIAlertController(title: "Pause", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default)  { _ in
            self.playGame()
            })
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // Function to give pause attributes within pause alert
    func holdGame() {
        if self.scene?.view?.isPaused == true {

            // Stop movement, fade out, move to center, fade in
            player.removeAllActions()
            self.player.run(SKAction.fadeOut(withDuration: 1) , completion: {
                self.player.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
                self.player.run(SKAction.fadeIn(withDuration: 1), completion: {
                    self.scene?.view?.isPaused = false
                })
            })
        }
    }
    
    // Check if the game is over by looking at our lives left
    func diedOnce() {
        
        self.pauseGame()
        
        // check if remaining lifes exists
        if remainingLives <= 0 || score >= 50 {
            showGameOverAlert()
        }
        else {
            
            print("Player died and will continue with next life")
            
            // Remove one life from hud
            if remainingLives > 1 {
                print(lifeNodes.count)
                lifeNodes[remainingLives - 1].alpha = 0.0
                remainingLives -= 1
            }
            
            // Stop movement, fade out, move to center, fade in
            self.playGame()
            continueBTN.removeFromParent()
            continueButton()
        }
    }
    
    // Displays the game over screen
    func showGameOverAlert() {
        self.removeAllActions()
        pauseGame()
        self.gameOver = true
        
        self.gameCenterDelegate?.reportScore(self.score)
        self.gameCenterDelegate?.showLeaderboard()
        
        // Continue with alert message
        let alert = UIAlertController(title: "Game Over", message: "Score: \(score)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)  { _ in
            
            // Restore lifes in HUD
            for i in 1..<remainingLives {
                lifeNodes[i].alpha = 1.0

            }
            
            // Restart level
            self.restartScene()
            self.playGame()
            })
        
        // show alert
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    
    /******************************** Game Center Section ************************************/
    // MARK: - Game Center

    // Achievements function
    func updateAchievements() {
        
        // Achievement - 100 Power Ups = 1 extra life *****************************************
        if (powerUpCount == 100) {
            
            powerUpAchievement = GKAchievement(identifier: achPowerUpID)
            
            powerUpAchievement?.percentComplete = Double(powerUpCount / 100)
            powerUpAchievement?.showsCompletionBanner = true
            
            GKAchievement.report([powerUpAchievement!], withCompletionHandler: nil)
        }
        
        // Incremental achievement ************************************************************
        if score <= 500 {
            
            let achievement = GKAchievement(identifier: ach500KillsID)
            
            achievement.percentComplete = Double(score / 500)
            achievement.showsCompletionBanner = true  // use Game Center's UI
            
            GKAchievement.report([achievement], withCompletionHandler: nil)
        }
        if score <= 50 {
            progressPercentage = score * 500 / 50
            achievementIdentifier = ach500KillsID
        }
        else if score <= 125 {
            progressPercentage = score * 500 / 125
            achievementIdentifier = ach500KillsID
        }
        else if score <= 250 {
            progressPercentage = score * 500 / 250
            achievementIdentifier = ach500KillsID
        }
        do {
            progressPercentage = score * 500 / 500
            achievementIdentifier = ach500KillsID
        }
        scoreAchievement = GKAchievement(identifier: ach500KillsID)
        scoreAchievement?.percentComplete = Double(progressPercentage)
    
        // Load the user's current achievement progress anytime
        GKAchievement.loadAchievements() { achievements, error in
            guard let achievements = achievements else { return }
            
            print(achievements)
        }
    }
    
    
    /********************************** Simulating Physics ***************************************/
    // MARK: - Simulate Physics
    
    override func didSimulatePhysics() {
        
    }
    
    
    /*********************************** Random Functions ****************************************/
    // MARK: - Simulate Physics
    
    func randomBetweenNumbers(_ firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func randomInRange(_ range: Range<Int>) -> Int {
        let count = UInt32(range.upperBound - range.lowerBound)
        return  Int(arc4random_uniform(count)) + range.lowerBound
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    func random(_ min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return random() * (max - min) + min
    }
}
