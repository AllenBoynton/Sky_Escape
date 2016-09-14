//
//  GameScene.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/3/16.
//  Copyright (c) 2016 Full Sail. All rights reserved.
//

import SpriteKit
import AVFoundation
//import Shephertz_App42_iOS_API

// Binary connections for collision and colliding
struct PhysicsCategory {
    
    static let None         : UInt32 = 0    // 0
    static let Ground1      : UInt32 = 1    // 0x1 << 0
    static let MyBullets2   : UInt32 = 2    // 0x1 << 1
    static let MyPlane4     : UInt32 = 4    // 0x1 << 2
    static let Enemy8       : UInt32 = 8    // 0x1 << 3
    static let EnemyFire16  : UInt32 = 16   // 0x1 << 4
    static let PowerUp32    : UInt32 = 32   // 0x1 << 5
    static let Coins64      : UInt32 = 64   // 0x1 << 6
    static let SkyBombs128  : UInt32 = 128  // 0x1 << 7
    static let Bombs256     : UInt32 = 256  // 0x1 << 8
    static let Turret512    : UInt32 = 512  // 0x1 << 9
    static let Soldiers1024 : UInt32 = 1024 // 0x1 << 10
    static let Tanks2048    : UInt32 = 2048 // 0x1 << 11
    static let Missiles4096 : UInt32 = 4096 // 0x1 << 12
    static let All          : UInt32 = UInt32.max // all nodes
}

// Global emitter objects
var smokeTrail = SKEmitterNode(fileNamed: "SmokeTrail")!
var smoke = SKEmitterNode(fileNamed: "Smoke")!
var explode = SKEmitterNode(fileNamed: "Explode")!
var explosion = SKEmitterNode(fileNamed: "FireExplosion")!

// Global sound
// Audio nodes for sound effects and music
var audioPlayer = AVAudioPlayer()
//var player = AVAudioEngine()
//var audioFile = AVAudioFile()
//var audioPlayerNode = AVAudioPlayerNode()
//var airplaneFlyBySound = SKAudioNode(fileNamed: "airplaneFlyBy")
//var airplaneP51Sound = SKAudioNode(fileNamed: "airplanep51")
var bGCannonsSound = SKAudioNode(fileNamed: "bGCannons")
var bgMusic = SKAudioNode(fileNamed: "bgMusic")
var biplaneFlyingSound = SKAudioNode(fileNamed: "biplaneFlying")
var bombSound = SKAudioNode(fileNamed: "bombaway")
var coinSound = SKAudioNode(fileNamed: "coin")
var crashSound = SKAudioNode(fileNamed: "crash")
//var gunfireSound = SKAudioNode(fileNamed: "gunfire")
//var mortarSound = SKAudioNode(fileNamed: "mortar")
//var mp5GunSound = SKAudioNode(fileNamed: "mp5Gun")
//var planeMGunSound = SKAudioNode(fileNamed: "planeMachineGun")
var powerUpSound = SKAudioNode(fileNamed: "powerUp")
//var propSound = SKAudioNode(fileNamed: "prop")
//var rocketSound = SKAudioNode(fileNamed: "rocket")
var shootSound = SKAudioNode(fileNamed: "shoot")
//var skyBoomSound = SKAudioNode(fileNamed: "skyBoom")
var startGameSound = SKAudioNode(fileNamed: "startGame")
//var tankSound = SKAudioNode(fileNamed: "tank")
//var tankFiringSound = SKAudioNode(fileNamed: "tankFiring")

// HUD global variables
let maxHealth = 100
let healthBarWidth: CGFloat = 170
let healthBarHeight: CGFloat = 10
let playerHealthBar = SKSpriteNode()

let darkenOpacity: CGFloat = 0.5
let darkenDuration: CFTimeInterval = 2

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /************************** Property constants declared ************/
    // MARK: - Property constants declared
    
    // Location for touch screen
    var touchLocation = CGPointZero
    
    // Image atlas's for animation
    var animation = SKAction()
    var frames = [SKTexture]()
    
    // Animation setup class
    let node = SKNode()
    var player = SKSpriteNode()
    var textureArray = [SKTexture]()
    
    // Player's weapons & allies
    var bullet = SKSpriteNode()
    var bombs = SKSpriteNode()
    
    // Ally planes
    var bomber = SKSpriteNode()
    var wingman = SKSpriteNode()
    var fokker = SKSpriteNode()
    var fokkerAlly = SKSpriteNode()
    var randomAlly = SKSpriteNode()
    var wingmenArray = [SKTexture]()
    
    // My backgrounds
    var myBackground = SKTexture()
    var midground = SKTexture()
    var foreground = SKTexture()
    
    // Enemy planes - static, straight
    var enemy = SKSpriteNode()
    var myEnemy1 = SKSpriteNode()
    var myEnemy2 = SKSpriteNode()
    var enemyArray = [SKSpriteNode]()
    var randomEnemy = SKSpriteNode()
    var enemyFire = SKSpriteNode()
    
    // Enemy planes - random pathway
    var fokker1: SKSpriteNode!
    var fokker2: SKSpriteNode!
    var randomFokker: SKSpriteNode!
    var fokkerFire: SKSpriteNode!
    
    // Sky nodes
    var powerUps = SKSpriteNode()
    var coins = SKSpriteNode()
    
    // Ground troops
    var tanks = SKSpriteNode()
    var shooterTanks = SKSpriteNode()
    var turret = SKSpriteNode()
    var missiles = SKSpriteNode()
    var soldierWalk = SKSpriteNode()
    var soldierShoot = SKSpriteNode()
    
    // Atlas group
    var attackAtlas = SKTextureAtlas()
    var allyAtlas = SKTextureAtlas(named: "AllyPlanes")
//    var attackDamagedAtlas = SKTextureAtlas(named: "AttackDamaged")
//    var deathAtlas = SKTextureAtlas(named: "Death")
//    var downDamageAtlas = SKTextureAtlas(named: "DownDamage")
//    var hitAtlas = SKTextureAtlas(named: "Hit")
//    var hitDamagedAtlas = SKTextureAtlas(named: "HitDamaged")
//    var upDamagedAtlas = SKTextureAtlas(named: "UpDamage")
//    var enemyArrayAtlas = SKTextureAtlas(named: "EnemyArray")
//    var enemy1Atlas = SKTextureAtlas(named: "Enemy1Attack")
//    var enemy2Atlas = SKTextureAtlas(named: "Enemy2Attack")
//    var enemyDie1Atlas = SKTextureAtlas(named: "Enemy1Die")
//    var enemyDie2Atlas = SKTextureAtlas(named: "Enemy2Die")
//    var soldierShootAtlas = SKTextureAtlas(named: "SoldierShoot")
//    var soldierWalkAtlas = SKTextureAtlas(named: "SoldierWalk")
//    var turretAtlas = SKTextureAtlas(named: "Turret")
//    var tankForwardAtlas = SKTextureAtlas(named: "TankForward")
//    var tankAttackAtlas = SKTextureAtlas(named: "TankAttack")
//    var powerUpsAtlas = SKTextureAtlas(named: "PowerUps")
//    var coinsAtlas = SKTextureAtlas(named: "Coins")
    
    // Game metering GUI
    var startButton = SKSpriteNode()
    var score = 0
    var powerUpCount = 0
    var coinCount = 0
    var health = 50
    var playerHP = maxHealth
    var gameOver = Bool()
    var gamePaused = Bool()
    var gameStarted = Bool()
    
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
    var gameOverLabel: SKLabelNode?
    
    
    /************************************* didMoveToView Function **********************************/
    // MARK: - didMoveToView
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Sets the physics delegate and physics body
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        physicsWorld.contactDelegate = self // Physics delegate set
        
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
                
                /* Allows to tap on screen and plane will present
                 at that axis and shoot at point touched */
                
                player.position.y = location.y // Allows a tap to touch on the y axis
                player.position.x = location.x // Allows a tap to touch on the x axis
                
                
                // Call function when play sound
                let startGameSound = SKAction.playSoundFileNamed("startGame", waitForCompletion: false)
                playSound(startGameSound)
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.fireBombs))
                self.view!.addGestureRecognizer(tapRecognizer)
                tapRecognizer.numberOfTapsRequired = 2

                /* function opens up the HUD and makes the button accessible
                 also, has displays for health and score. */
                createHUD()
                
                let node = self.nodeAtPoint(location)
                if (node.name == "PauseButton") || (node.name == "PauseButtonContainer") {
                    showPauseAlert()
                }
                
                
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
                let xSpawn = randomBetweenNumbers(4.0, secondNum: 12.0)
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(spawnEnemyPlanes),
                    SKAction.waitForDuration(Double(xSpawn))
                    ])
                    ))
                
                // Creating enemy planes and put planes on a linear interpolation path
                let xSpawn2 = randomBetweenNumbers(2.0, secondNum: 10.0)
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(setupEnemyFokkers),
                    SKAction.waitForDuration(Double(xSpawn2))
                    ])
                    ))
                
                // Spawning enemy fire timer call
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(spawnEnemyFire),
                    SKAction.waitForDuration(1.5)
                    ])
                    ))
                
                // Spawning enemy fire timer call
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(enemyFokkerFire),
                    SKAction.waitForDuration(2.5)
                    ])
                    ))
                
                // Tank spawn timer
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(setupTank),
                    SKAction.waitForDuration(45.0)
                    ])
                    ))
                
                // Shooting tank spawn timer
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(setupShootingTank),
                    SKAction.waitForDuration(110.0)
                    ])
                    ))
                
                // Shooting tank spawn timer
                let xSpawn3 = randomBetweenNumbers(2.0, secondNum: 10.0)
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(setupSoldiers),
                    SKAction.waitForDuration(Double(xSpawn3))
                    ])
                    ))
                
                // Tank missile spawn timer
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(spawnTankMissiles),
                    SKAction.waitForDuration(5.0)
                    ])
                    ))
                
                // Turret spawn timer
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(setupTurret),
                    SKAction.waitForDuration(60)
                    ])
                    ))

                // Turret missile spawn timer
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(spawnTurretMissiles),
                    SKAction.waitForDuration(5.0)
                    ])
                    ))
                
                // Shooting soldiers spawn timer
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(setupShooters),
                    SKAction.waitForDuration(20)
                    ])
                    ))
                
                // Sky bomb spawn timer
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(skyExplosions),
                    SKAction.waitForDuration(10.0)
                    ])
                    ))
                
                // Spawning power up timer call
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(spawnPowerUps),
                    SKAction.waitForDuration(120)
                    ])
                    ))
                
                // Set enemy tank spawn intervals
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(spawnCoins),
                    SKAction.waitForDuration(30)
                    ])
                    ))
                
                
                /**************************** Preloading Sound & Music ****************************/
                // MARK: - Spawning
                                
                // After import AVFoundation, needs do,catch statement to preload sound so no delay
                
//                    do {
//                        let sounds = [/*"airplaneFlyBy", "airplanep51", "bGCannons", "bgMusic", "biplaneFlying", "bombaway",*/ "coin", "crash"/*,  "gunfire", "mortar", "mp5Gun", "planeMachineGun"*/, "powerUp"/*, "prop", "rocket"*/, "shoot"/*, "skyBoom"*/, "startGame"/*, "tank", "tankFiring"*/]
//                        
//                        for sound in sounds {
//                            
//                            let player = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(sound, ofType: "mp3")!))
//                            
//                            player.prepareToPlay()
//                            
//                        }
//                    } catch {
//                        print("AVAudio has had an \(error).")
//                    }
//                
//                // Adds background sound to game
//                bgMusic.runAction(SKAction.play())
//                bgMusic.autoplayLooped = true
//                bgMusic.removeFromParent()
//                self.addChild(bgMusic)
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
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
    
    
    /*********************************** Update Function *****************************************/
    // MARK: - Update Function
    
    // Update for animations and positions
    override func update(currentTime: NSTimeInterval) {
        
        if !self.gamePaused {
            holdGame()
            self.scene!.view?.paused = false
        }
        
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
        if(health <= 10) {
            healthLabel.fontColor = SKColor.redColor()
        }
        
        // Updates check stats to see if health is 0
//        checkIfGameIsOver()
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
            ground.physicsBody?.collisionBitMask = PhysicsCategory.None
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
        
        player = SKScene(fileNamed: "Player")!.childNodeWithName("player")! as! SKSpriteNode
        
        player.position = CGPoint(x: self.size.width / 6, y: self.size.height / 2)
        player.name = "Player"
        player.setScale(0.8)
        player.zPosition = 100

        player.removeFromParent()
        addChild(player) // Add plane to the scene
        
        // Body physics for player's planes
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.categoryBitMask = PhysicsCategory.MyPlane4
        player.physicsBody?.contactTestBitMask = PhysicsCategory.EnemyFire16 | PhysicsCategory.Enemy8 | PhysicsCategory.Missiles4096 | PhysicsCategory.Ground1 | PhysicsCategory.Coins64 | PhysicsCategory.PowerUp32 | PhysicsCategory.SkyBombs128
        player.physicsBody?.dynamic = false
        
        // Bi plane sound
//        biplaneFlyingSound.runAction(SKAction.play())
//        biplaneFlyingSound.removeFromParent()
//        self.addChild(biplaneFlyingSound)
    }
    
    // Create the ammo for our plane to fire
    func fireBullets() {
        
        bullet = SKScene(fileNamed: "FireBullet")!.childNodeWithName("fireBullet")! as! SKSpriteNode

        bullet.position = CGPoint(x: player.position.x - player.size.width / 2 + 20, y: player.position.y + 5)
        bullet.name = "FireBullet"
        bullet.setScale(0.8)
        bullet.zPosition = 80
        
        bullet.removeFromParent()
        addChild(bullet)
        
        // Body physics for plane's bulets
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.MyBullets2
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy8 | PhysicsCategory.Missiles4096 | PhysicsCategory.Soldiers1024
        bullet.physicsBody?.dynamic = false
        
        // Shoot em up!
        let action = SKAction.moveToX(self.size.width + 150, duration: 1.5)
        let actionDone = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([action, actionDone]))
        
        // Add gun sound
        shootSound.runAction(SKAction.play())
        shootSound.autoplayLooped = false
        shootSound.removeFromParent()
        self.addChild(shootSound)
    }

    // Create the bombs for our plane to drop
    func fireBombs() {
        
        bombs = SKScene(fileNamed: "Bombs")!.childNodeWithName("bomb")! as! SKSpriteNode
        
        bombs.position = CGPoint(x: player.position.x, y: player.position.y)
        bombs.name = "Bombs"
        bombs.setScale(0.1)
        bombs.zPosition = 80
        
        bombs.removeFromParent()
        addChild(bombs)
        
        // Body physics for plane's bombs
        bombs.physicsBody = SKPhysicsBody(rectangleOfSize: bombs.size)
        bombs.physicsBody?.categoryBitMask = PhysicsCategory.Bombs256
        bombs.physicsBody?.contactTestBitMask = PhysicsCategory.Tanks2048 | PhysicsCategory.Turret512 | PhysicsCategory.Soldiers1024 | PhysicsCategory.Enemy8
        bombs.physicsBody?.dynamic = true
        
        let moveBombAction = SKAction.moveToY(-100, duration: 2.0)
        let removeBombAction = SKAction.removeFromParent()
        bombs.runAction(SKAction.sequence([moveBombAction,removeBombAction]))
    
        // Add gun sound
        bombSound.runAction(SKAction.play())
        bombSound.autoplayLooped = false
        bombSound.removeFromParent()
//        self.addChild(bombSound)
    }
    
    // Adding ally forces in background
    func spawnWingman() {
        
        // Wingmen passby's in the distance
        for i in 1...allyAtlas.textureNames.count {
            let ally = "wingman\(i)"
            
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
        powerUps.physicsBody = SKPhysicsBody(circleOfRadius: size.height/2)
        powerUps.physicsBody?.categoryBitMask = PhysicsCategory.PowerUp32
        powerUps.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
        powerUps.physicsBody?.dynamic = false
        
        // Add sound
        powerUpSound = SKAudioNode(fileNamed: "powerUp")
        powerUpSound.runAction(SKAction.play())
        powerUpSound.autoplayLooped = false
        powerUpSound.removeFromParent()
        self.addChild(powerUpSound)
    }
    
    // Spawning coins
    func spawnCoins() {
        
        // Add user's animated coins
        coins = SKScene(fileNamed: "Coins")!.childNodeWithName("coins")! as! SKSpriteNode
        
        // Star position off screen
        let xPos = randomBetweenNumbers(0, secondNum: self.frame.width )
        let randomY = CGFloat(arc4random_uniform(700) + 250)
        
        // Sky bomb position on screen
        coins.position = CGPoint(x: xPos, y: randomY)
        coins.name = "Coins"
        coins.setScale(1.0)
        coins.zPosition = 100
        
        coins.removeFromParent()
        self.addChild(coins) // Add coins to the scene
        
        // Body physics for coins
        coins.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        coins.physicsBody?.categoryBitMask = PhysicsCategory.Coins64
        coins.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
        coins.physicsBody?.dynamic = false
        
        // Add sound
        coinSound = SKAudioNode(fileNamed: "coin")
        coinSound.runAction(SKAction.play())
        coinSound.autoplayLooped = false
        coinSound.removeFromParent()
        self.addChild(coinSound)
    }
    

    /*********************************** Spawning Enemies *********************************/
    // MARK: - Spawning Enemy Functions
    
    // Spawn sky nodes
    func skyExplosions() {
        
        // Sky explosions of a normal battle
        explosion = SKEmitterNode(fileNamed: "FireExplosion")!
        
//        explosion = (SKScene(fileNamed: "FireExplosion")!.childNodeWithName("explosion") as? SKEmitterNode)!
        explosion.name = "Explosion"
        explosion.zPosition = 75
        
        let xPos = randomBetweenNumbers(0, secondNum: self.frame.width )
        let randomY = CGFloat(arc4random_uniform(700) + 250)
        
        // Sky bomb position on screen
        explosion.position = CGPoint(x: xPos, y: randomY)
        
        explosion.removeFromParent()
        self.addChild(explosion)
        
        // Body physics for plane's bombs
        explosion.physicsBody = SKPhysicsBody(circleOfRadius: size.height/2)
        explosion.physicsBody?.categoryBitMask = PhysicsCategory.SkyBombs128
        explosion.physicsBody?.contactTestBitMask = PhysicsCategory.All
        explosion.physicsBody?.dynamic = true
        
//        skyBoomSound.runAction(SKAction.play())
//        skyBoomSound.autoplayLooped = false
//        skyBoomSound.removeFromParent()
//        self.addChild(skyBoomSound)
    }
    
    // Generate enemy fighter planes
    func spawnEnemyPlanes() {
        
        let enemy1 = SKScene(fileNamed: "EnemyPlanes")!.childNodeWithName("enemy1")! as! SKSpriteNode
        let enemy2 = SKScene(fileNamed: "EnemyPlanes")!.childNodeWithName("enemy2")! as! SKSpriteNode
        let enemy3 = SKScene(fileNamed: "EnemyPlanes")!.childNodeWithName("enemy3")! as! SKSpriteNode
        let enemy4 = SKScene(fileNamed: "EnemyPlanes")!.childNodeWithName("enemy4")! as! SKSpriteNode
        
        enemyArray = [enemy1, enemy2, enemy3, enemy4]
        
        // Generate a random index
        let randomIndex = Int(arc4random_uniform(UInt32(enemyArray.count)))
        
        // Get a random enemy
        randomEnemy = (enemyArray[randomIndex])

        randomEnemy.setScale(0.25)
        randomEnemy.zPosition = 90
        
        // Calculate random spawn points for air enemies
        let randomY = CGFloat(arc4random_uniform(650) + 350)
        randomEnemy.position = CGPoint(x: self.size.width, y: randomY)

        // Add enemies
        randomEnemy.removeFromParent()
        addChild(randomEnemy)
        
        // Added randomEnemy's physics
        randomEnemy.physicsBody = SKPhysicsBody(rectangleOfSize: randomEnemy.size)
        randomEnemy.name = "EnemyPlanes"
        randomEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy8
        randomEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4 | PhysicsCategory.Enemy8 | PhysicsCategory.MyBullets2 | PhysicsCategory.Bombs256 | PhysicsCategory.SkyBombs128
        randomEnemy.physicsBody?.dynamic = false
        
        // Move enemies forward with random intervals
        let actualDuration = random(min: 3.0, max: 6.0)
        
        // Create a path func for planes to randomly follow {
        let actionMove = SKAction.moveTo(CGPoint(x: -randomEnemy.size.width / 2, y: randomY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        randomEnemy.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    
        // Add sound
//        airplaneFlyBySound = SKAudioNode(fileNamed: "airplaneFlyBy")
//        airplaneFlyBySound.runAction(SKAction.play())
//        airplaneFlyBySound.autoplayLooped = false
//        airplaneFlyBySound.removeFromParent()
//        self.addChild(airplaneFlyBySound)// Alternative sounds to choose from
        
//        spawnEnemyFire()
    }
    
    // Setup special enemy fighters that move randomly
    func setupEnemyFokkers() {

        // Animation of first enemy random pathway plane
        fokker1 = SKScene(fileNamed: "EnemyPlanes")!.childNodeWithName("enemy1Attack")! as! SKSpriteNode
        fokker2 = SKScene(fileNamed: "EnemyPlanes")!.childNodeWithName("enemy2Attack")! as! SKSpriteNode
        
        let planeEnemy = [fokker1, fokker2]
        
        // Generate a random index
        let randomIndex = Int(arc4random_uniform(UInt32(planeEnemy.count)))
        
        // Get a random enemy
        randomFokker = planeEnemy[randomIndex]
        
        // Planes position off screen
        let actualY = CGFloat(arc4random_uniform(700) + 250)
        randomFokker.position = CGPoint(x: self.size.width, y: actualY)
        randomFokker.zPosition = 90
        randomFokker.setScale(0.7)
        
        fokker1.removeFromParent()
        fokker2.removeFromParent()
        randomFokker.removeFromParent()
        self.addChild(randomFokker) // Add enemy fokker plane to scene
        
        // Added randomEnemy's physics
        randomFokker.physicsBody = SKPhysicsBody(rectangleOfSize: randomFokker.size)
        randomFokker.name = "EnemyFokkers"
        randomFokker.physicsBody?.categoryBitMask = PhysicsCategory.Enemy8
        randomFokker.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4 | PhysicsCategory.Enemy8 | PhysicsCategory.MyBullets2 | PhysicsCategory.Bombs256 | PhysicsCategory.SkyBombs128
        randomFokker.physicsBody?.dynamic = false
        
        // This time I will determine speed by velocity rather than time interval
        let actualDuration = random(min: 1.0, max: 4.0)
        
        // Create a path func for planes to randomly follow {
        let flyAcrossScreen = SKAction.moveTo(CGPoint(x: -randomFokker.size.width / 2, y: actualY), duration: NSTimeInterval(actualDuration))
        let move1 = SKAction.moveByX(-175, y: actualY, duration: 0.5)
        let move2 = SKAction.moveByX(-225, y: -(actualY), duration: 0.5)
        let flyOff = SKAction.moveTo(CGPoint(x: -randomFokker.size.width / 2, y: -100), duration: 2)
        let allActions = SKAction.sequence([flyAcrossScreen, move1, move2, flyOff])
        let actionMoveDone = SKAction.removeFromParent()
        randomFokker.runAction(SKAction.sequence([allActions, actionMoveDone]))
    }
    
    // Function to allow all enemy planes to get setup and fire
    func spawnEnemyFire() {
        
        enemyFire = SKScene(fileNamed: "EnemyFire")!.childNodeWithName("bullet")! as! SKSpriteNode
        
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
        enemyFire.physicsBody?.dynamic = false
        
        // Change attributes
        enemyFire.color = UIColor.yellowColor()
        enemyFire.colorBlendFactor = 1.0
        
        // Shoot em up!
        let action = SKAction.moveToX(-50, duration: 1.0)
        let actionDone = SKAction.removeFromParent()
        enemyFire.runAction(SKAction.sequence([action, actionDone]))
    }
    
    // Function to allow all enemy planes to get setup and fire
    func enemyFokkerFire() {
        
        fokkerFire = SKScene(fileNamed: "EnemyFire")!.childNodeWithName("bullet")! as! SKSpriteNode
        
        // Positioning enemyFire to randomEnemy group
        fokkerFire.position = CGPointMake(randomFokker.position.x - 100, randomFokker.position.y)
        
        fokkerFire.name = "FokkerFire"
        fokkerFire.setScale(0.2)
        fokkerFire.zPosition = 100
        
        fokkerFire.removeFromParent()
        addChild(fokkerFire) // Generate enemy fire
        
        // Added FokkerFire physics
        fokkerFire.physicsBody = SKPhysicsBody(rectangleOfSize: fokkerFire.size)
        fokkerFire.physicsBody?.categoryBitMask = PhysicsCategory.EnemyFire16
        fokkerFire.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
        fokkerFire.physicsBody?.dynamic = false
        
        // Change attributes
        fokkerFire.color = UIColor.cyanColor()
        fokkerFire.colorBlendFactor = 1.0
        
        // Shoot em up!
        let action = SKAction.moveToX(-50, duration: 0.8)
        let actionDone = SKAction.removeFromParent()
        fokkerFire.runAction(SKAction.sequence([action, actionDone]))
    }

    // Spawn ground tank - it can't fly!! ;)
    func setupTank() {
        
        // Move a tank across the screen
        tanks = SKScene(fileNamed: "Tanks")!.childNodeWithName("tankForward")! as! SKSpriteNode
        
        // Move tank
        tanks.position = CGPoint(x: -self.size.width / 2, y: 100)
        tanks.name = "Tanks"
        tanks.setScale(1.25)
        tanks.zPosition = 145
        
        tanks.removeFromParent()
        addChild(tanks) // Add tank to scene
        
        // Added tank physics
        tanks.physicsBody = SKPhysicsBody(rectangleOfSize: tanks.size)
        tanks.physicsBody?.categoryBitMask = PhysicsCategory.Tanks2048
        tanks.physicsBody?.collisionBitMask = PhysicsCategory.None
        tanks.physicsBody?.dynamic = true
        
        // Move tank forward
        let driveAcrossScreen = SKAction.moveTo(CGPoint(x: size.width +
            tanks.size.width / 2, y: 100), duration: 20)
        
        tanks.runAction(driveAcrossScreen) // Moves enemy tank across screen
        
        // Turn tank around
        let flip = SKAction.scaleXTo(-1.2, duration: 1.5)
        let backUp = SKAction.moveByX(-600, y: 0, duration: 5)
        let wait = SKAction.moveByX(-175, y: 0, duration: 3.5)
        let driveOff = SKAction.moveTo(CGPoint(x: -tanks.size.width / 2, y: 100), duration: 6)
        let tankActions = SKAction.sequence([driveAcrossScreen, flip, backUp, wait, driveOff])
        
        tanks.runAction(tankActions)
    }

    // Spawn ground tank - it can't fly!! ;)
    func setupShootingTank() {
        
        // Move a tank across the screen
        shooterTanks = SKScene(fileNamed: "Tanks")!.childNodeWithName("tankAttack")! as! SKSpriteNode
        
        // Move tank
        shooterTanks.position = CGPoint(x: self.size.width, y: 150)
        shooterTanks.name = "ShootingTanks"
        shooterTanks.setScale(1.25)
        shooterTanks.zPosition = 125
        
        shooterTanks.removeFromParent()
        addChild(shooterTanks) // Add tank to scene
        
        // Added tank's physics
        shooterTanks.physicsBody = SKPhysicsBody(rectangleOfSize: shooterTanks.size)
        shooterTanks.physicsBody?.categoryBitMask = PhysicsCategory.Tanks2048
        shooterTanks.physicsBody?.collisionBitMask = PhysicsCategory.None
        shooterTanks.physicsBody?.dynamic = false
        
        // Move tank forward and fire
        let driveMidScreen = SKAction.moveByX(self.size.width, y: 150, duration: 5)
        let wait = SKAction.moveByX(-300, y: 0, duration: 10)
        let driveOff = SKAction.moveTo(CGPoint(x: -shooterTanks.size.width / 2, y: 50), duration: 6)
        let tankActions = SKAction.sequence([driveMidScreen, wait, driveOff])
        
        shooterTanks.runAction(tankActions)
    }
    
    // Spawn enemy tank missiles
    func spawnTankMissiles() {
        
        // Spawning an enemy tank's anti-aircraft missiles
        missiles = SKScene(fileNamed: "Missiles")!.childNodeWithName("tankMissile")! as! SKSpriteNode
        missiles.setScale(0.5)
        missiles.zPosition = 149
        
        missiles.position = CGPoint(x: shooterTanks.position.x - 50, y: shooterTanks.position.y)
        
        missiles.removeFromParent()
        self.addChild(missiles) // Generate tank missile
        
        // Added tank's missile physics
        missiles.physicsBody = SKPhysicsBody(rectangleOfSize: missiles.size)
        missiles.name = "TankMissiles"
        missiles.physicsBody?.categoryBitMask = PhysicsCategory.Missiles4096
        missiles.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
        missiles.physicsBody?.dynamic = false
        
        // Shoot em up!
        if shooterTanks.position.y < self.frame.height {
            let action = SKAction.moveTo(CGPoint(x: -65, y: self.size.height + 80), duration: 3.0)
            let actionDone = SKAction.removeFromParent()
            missiles.runAction(SKAction.sequence([action, actionDone]))
        }
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
        turret.physicsBody?.categoryBitMask = PhysicsCategory.Turret512
        turret.physicsBody?.collisionBitMask = PhysicsCategory.None
        turret.physicsBody?.dynamic = false
        
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
        
        missiles.position = CGPoint(x: turret.position.x - 40, y: turret.position.y + 20)
        
        missiles.removeFromParent()
        self.addChild(missiles) // Generate tank missile
        
        // Added turret's missile physics
        missiles.physicsBody = SKPhysicsBody(rectangleOfSize: missiles.size)
        missiles.physicsBody?.categoryBitMask = PhysicsCategory.Missiles4096
        missiles.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
        missiles.physicsBody?.dynamic = false
        
        // Shoot em up!
        let action = SKAction.moveTo(CGPoint(x: -75, y: self.size.height + 80), duration: 3.0)
        let actionDone = SKAction.removeFromParent()
        missiles.runAction(SKAction.sequence([action, actionDone]))
    }
    
    // Spawning a walking soldier
    func setupSoldiers() {
        
        // Allows for random y axis spawning
        let yPos = randomBetweenNumbers(150, secondNum: 225)

        // Add user's animated walking soldiers
        soldierWalk = SKScene(fileNamed: "Soldiers")!.childNodeWithName("soldierWalk")! as! SKSpriteNode
        
        // Sky bomb position on screen
        soldierWalk.position = CGPoint(x: self.frame.width, y: yPos)
        soldierWalk.name = "Soldiers"
        soldierWalk.zPosition = 120
        
        soldierWalk.removeFromParent()
        self.addChild(soldierWalk)
        
        // Added soldier's physics
        soldierWalk.physicsBody = SKPhysicsBody(rectangleOfSize: soldierWalk.size)
        soldierWalk.physicsBody?.categoryBitMask = PhysicsCategory.Soldiers1024
        soldierWalk.physicsBody?.contactTestBitMask = PhysicsCategory.Bombs256 | PhysicsCategory.MyBullets2 | PhysicsCategory.MyPlane4
        soldierWalk.physicsBody?.dynamic = false
        
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
        soldierShoot.position = CGPoint(x: self.frame.width, y: 185)
        soldierShoot.name = "Shooters"
        soldierShoot.zPosition = 120
        
        soldierShoot.removeFromParent()
        self.addChild(soldierShoot)
        
        // Added shooter's physics
        soldierShoot.physicsBody = SKPhysicsBody(rectangleOfSize: soldierShoot.size)
        soldierShoot.physicsBody?.categoryBitMask = PhysicsCategory.Soldiers1024
        soldierShoot.physicsBody?.contactTestBitMask = PhysicsCategory.Bombs256 | PhysicsCategory.MyBullets2 | PhysicsCategory.MyPlane4
        soldierShoot.physicsBody?.dynamic = false
        
        // Move soldiers forward
        let shootPlanes = SKAction.moveTo(CGPoint(x: -40, y: 185), duration: 35)
        let actionRepeat = SKAction.removeFromParent()
        soldierShoot.runAction(SKAction.sequence([shootPlanes, actionRepeat]))
    }

    
    
    
    /************************************ didBeginContact *****************************************/
    // MARK: - didBeginContact
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var contactBody1: SKPhysicsBody
        var contactBody2: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactBody1 = contact.bodyA
            contactBody2 = contact.bodyB
        } else {
            contactBody1 = contact.bodyB
            contactBody2 = contact.bodyA
        }
        
        // Ground VS MyPlane
        if ((contactBody1.categoryBitMask == 1) && (contactBody2.categoryBitMask == 4)) {
            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
            smoke = SKEmitterNode(fileNamed: "Smoke")!
            
            explosion.position = (contactBody1.node?.position)!
            smoke.position = (contactBody1.node?.position)!
            
            self.addChild(explosion)
            self.addChild(smoke)
            
            runAction(SKAction.waitForDuration(2), completion: { explosion.removeFromParent() })
            runAction(SKAction.waitForDuration(3), completion: { smoke.removeFromParent() })
            
            contactBody2.node?.removeFromParent()
            
            crashSound = SKAudioNode(fileNamed: "crash")
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
            
            // Check points
            health = 0
//            checkIfGameIsOver()
        }
            // MyBullet VS Planes
        else if((contactBody1.categoryBitMask == 2) && (contactBody2.categoryBitMask == 8)) {
            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
            smoke = SKEmitterNode(fileNamed: "Smoke")!
            
            explosion.position = (contactBody2.node?.position)!
            smoke.position = (contactBody2.node?.position)!
            
            self.addChild(explosion)
            self.addChild(smoke)
            
            runAction(SKAction.waitForDuration(2), completion: { explosion.removeFromParent() })
            runAction(SKAction.waitForDuration(3), completion: { smoke.removeFromParent() })
            
            contactBody2.node?.removeFromParent()
            contactBody1.node?.removeFromParent()
            
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
            
            // Hitting an the enemy adds score and health
            score += 1
        }
            // Bombs VS Tanks
        else if((contactBody1.categoryBitMask == 256) && (contactBody2.categoryBitMask == 2048)) {
            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
            smoke = SKEmitterNode(fileNamed: "Smoke")!
            
            explosion.position = (contactBody2.node?.position)!
            smoke.position = (contactBody2.node?.position)!
            
            self.addChild(explosion)
            self.addChild(smoke)
            
            runAction(SKAction.waitForDuration(2), completion: { explosion.removeFromParent() })
            runAction(SKAction.waitForDuration(3), completion: { smoke.removeFromParent() })
            
            contactBody2.node?.removeFromParent()
            contactBody1.node?.removeFromParent()
            
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
            
            // Hitting an the enemy adds score and health
            score += 2
        }
            // Bombs VS Turret
        else if((contactBody1.categoryBitMask == 256) && (contactBody2.categoryBitMask == 512)) {
            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
            smoke = SKEmitterNode(fileNamed: "Smoke")!
            
            explosion.position = (contactBody2.node?.position)!
            smoke.position = (contactBody2.node?.position)!
            
            self.addChild(explosion)
            self.addChild(smoke)
            
            runAction(SKAction.waitForDuration(2), completion: { explosion.removeFromParent() })
            runAction(SKAction.waitForDuration(3), completion: { smoke.removeFromParent() })
            
            contactBody2.node?.removeFromParent()
            contactBody1.node?.removeFromParent()
            
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
            
            // Hitting an the enemy adds score and health
            score += 2
        }
            // MyBullet VS Turret
        else if((contactBody1.categoryBitMask == 2) && (contactBody2.categoryBitMask == 512)) {
            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
            smoke = SKEmitterNode(fileNamed: "Smoke")!
            
            explosion.position = (contactBody2.node?.position)!
            smoke.position = (contactBody2.node?.position)!
            
            self.addChild(explosion)
            self.addChild(smoke)
            
            runAction(SKAction.waitForDuration(2), completion: { explosion.removeFromParent() })
            runAction(SKAction.waitForDuration(3), completion: { smoke.removeFromParent() })
            
            contactBody2.node?.removeFromParent()
            contactBody1.node?.removeFromParent()
            
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
            
            // Hitting an the enemy adds score and health
            score += 2
        }
            // MyBullet VS Soldiers
        else if((contactBody1.categoryBitMask == 2) && (contactBody2.categoryBitMask == 1024)) {
            contactBody2.node?.removeFromParent()
            contactBody1.node?.removeFromParent()
            
            // Hitting an the enemy adds score
            score += 1
        }
            // Bombs VS Soldiers
        else if ((contactBody1.categoryBitMask == 256) && (contactBody2.categoryBitMask == 1024)) {
            explode = SKEmitterNode(fileNamed: "Explode")!
            explode.position = (contactBody2.node?.position)!
            
            explode.removeFromParent()
            self.addChild(explode)
            
            contactBody1.node?.removeFromParent()
            contactBody2.node?.removeFromParent()
            
            // Calling pre-loaded sound of an explosion
            crashSound = SKAudioNode(fileNamed: "crash")
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
            
            // Points per each soldier hit
            score += 1
        }
            // Bomb vs ground
        else if ((contactBody1.categoryBitMask == 256) && (contactBody2.categoryBitMask == 1)) {
            explode = SKEmitterNode(fileNamed: "Explode")!
            explode.position = (contactBody2.node?.position)!
            
            explode.removeFromParent()
            self.addChild(explode)
            
            contactBody1.node?.removeFromParent()
            contactBody2.node?.removeFromParent()
            
            // Calling pre-loaded sound of an explosion
            crashSound = SKAudioNode(fileNamed: "crash")
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
        }
            // MyBullet VS Planes
        else if((contactBody1.categoryBitMask == 2) && (contactBody2.categoryBitMask == 4096)) {
            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
            smoke = SKEmitterNode(fileNamed: "Smoke")!
            
            explosion.position = (contactBody2.node?.position)!
            smoke.position = (contactBody2.node?.position)!
            
            self.addChild(explosion)
            self.addChild(smoke)
            
            runAction(SKAction.waitForDuration(2), completion: { explosion.removeFromParent() })
            runAction(SKAction.waitForDuration(3), completion: { smoke.removeFromParent() })
            
            contactBody2.node?.removeFromParent()
            contactBody1.node?.removeFromParent()
            
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
            
            // Hitting an the enemy adds score and health
            score += 1
        }
            // MyPlane VS Enemy plane
        else if((contactBody1.categoryBitMask == 4) && (contactBody2.categoryBitMask == 8)) {
            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
            smoke = SKEmitterNode(fileNamed: "Smoke")!
            
            explosion.removeFromParent()
            smoke.removeFromParent()
            self.addChild(explosion)
            self.addChild(smoke)
            
            explosion.position = contactBody2.node!.position
            smoke.position = contactBody2.node!.position
            
            runAction(SKAction.waitForDuration(2), completion: { explosion.removeFromParent() })
            runAction(SKAction.waitForDuration(3), completion: { smoke.removeFromParent() })
            
            contactBody1.node!.removeFromParent()
            player.removeFromParent()
            contactBody2.node!.removeFromParent()
            
            // Add explosion sound
            crashSound = SKAudioNode(fileNamed: "crash")
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
            
            // Configure points
            health = 0
//            checkIfGameIsOver()
        }
            // Player vs enemy bullets
        else if ((contactBody1.categoryBitMask == 4) && (contactBody2.categoryBitMask == 16)) {
            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
            
            explosion.position = contactBody1.node!.position
            explosion.removeFromParent()
            self.addChild(explosion)
            
            contactBody2.node!.removeFromParent()
            
            crashSound = SKAudioNode(fileNamed: "crash")
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
            
            health -= 1
            playerHP = max(0, health + 1)
        }
            // Player vs PowerUp
        else if ((contactBody1.categoryBitMask == 4) && (contactBody2.categoryBitMask == 32)) { // powerUps
            explode = SKEmitterNode(fileNamed: "Explode")!
            explode.position = contactBody2.node!.position
            
            explode.removeFromParent()
            self.addChild(explode)
            
            powerUps.removeFromParent()
            contactBody2.node!.removeFromParent()
            
            // Calling pre-loaded sound to the star hits
            powerUpSound = SKAudioNode(fileNamed: "powerUp")
            powerUpSound.runAction(SKAction.play())
            powerUpSound.autoplayLooped = false
            
            powerUpSound.removeFromParent()
            self.addChild(powerUpSound)
            
            // Points per star added to score and health
            health += 20
            powerUpCount += 1
            playerHP = max(0, health + 1)
        }
            // Player vs Coin
        else if ((contactBody1.categoryBitMask == 4) && (contactBody2.categoryBitMask == 64)) {
            explode = SKEmitterNode(fileNamed: "Explode")!
            explosion.position = contactBody2.node!.position
            
            explosion.removeFromParent()
            self.addChild(explosion)
            
            contactBody2.node!.removeFromParent()
            
            coinSound = SKAudioNode(fileNamed: "coin")
            coinSound.runAction(SKAction.play())
            coinSound.autoplayLooped = false
            coinSound.removeFromParent()
            self.addChild(coinSound)
            
            // Coins++
            coinCount += 1
        }
            
            // Skybomb VS Enemy
        else if ((contactBody1.categoryBitMask == 8) && (contactBody2.categoryBitMask == 512)) {
            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
            smoke = SKEmitterNode(fileNamed: "Smoke")!
            
            explosion.position = contactBody1.node!.position
            smoke.position = contactBody1.node!.position
            
            explosion.removeFromParent()
            smoke.removeFromParent()
            self.addChild(explosion)
            self.addChild(smoke)
            
            contactBody1.node!.removeFromParent()
            
            crashSound = SKAudioNode(fileNamed: "crash")
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
            
            // Sky bomb hits enemy - we get points
            score += 1
        }
            // MyPlane VS Enemy plane
        else if((contactBody1.categoryBitMask == 4) && (contactBody2.categoryBitMask == 4096)) {
            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
            smoke = SKEmitterNode(fileNamed: "Smoke")!
            
            explosion.removeFromParent()
            smoke.removeFromParent()
            self.addChild(explosion)
            self.addChild(smoke)
            
            explosion.position = contactBody2.node!.position
            smoke.position = contactBody2.node!.position
            
            runAction(SKAction.waitForDuration(2), completion: { explosion.removeFromParent() })
            runAction(SKAction.waitForDuration(3), completion: { smoke.removeFromParent() })
            
            contactBody1.node!.removeFromParent()
            player.removeFromParent()
            contactBody2.node!.removeFromParent()
            
            // Add explosion sound
            crashSound = SKAudioNode(fileNamed: "crash")
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
            
            // Configure points
            health = 0
//            checkIfGameIsOver()
        }
            // MyBullet VS Planes
        else if((contactBody1.categoryBitMask == 2) && (contactBody2.categoryBitMask == 8)) {
            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
            smoke = SKEmitterNode(fileNamed: "Smoke")!
            
            explosion.position = (contactBody2.node?.position)!
            smoke.position = (contactBody2.node?.position)!
            
            self.addChild(explosion)
            self.addChild(smoke)
            
            runAction(SKAction.waitForDuration(2), completion: { explosion.removeFromParent() })
            runAction(SKAction.waitForDuration(3), completion: { smoke.removeFromParent() })
            
            contactBody2.node?.removeFromParent()
            contactBody1.node?.removeFromParent()
            
            crashSound.runAction(SKAction.play())
            crashSound.autoplayLooped = false
            
            crashSound.removeFromParent()
            self.addChild(crashSound)
            
            // Hitting an the enemy adds score and health
            score += 1
        }

    }
    
    
    /*************************************** GUI ******************************************/
    // Show Pause Alert
    
    func showPauseAlert() {
        
        self.gamePaused = true
        let alert = UIAlertController(title: "Pause", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default)  { _ in
            self.gamePaused = false
            })
        self.view?.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func createHUD() {
        
        // Adding HUD with pause
        display = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.size.width, self.size.height * 0.06))
        display.anchorPoint = CGPointMake(0, 0)
        display.position = CGPointMake(0, self.size.height - display.size.height)
        display.zPosition = 15
        
        // Pause button container
        pauseNode.position = CGPoint(x: display.size.width / 2, y: display.size.height / 2)
        pauseNode.size = CGSizeMake(display.size.height * 3, display.size.height * 2.5)
        pauseNode.name = "PauseButtonContainer"
        
        // Pause button
        pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.zPosition = 1000
        pauseButton.size = CGSize(width: 75, height: 75)
        pauseButton.position = CGPoint(x: display.size.width / 2, y: display.size.height / 2 - 15)
        pauseButton.name = "PauseButton"
        
        // Health label
        healthLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        health = 20
        healthLabel.text = "Health: \(health)"
        healthLabel.fontSize = display.size.height
        healthLabel.fontColor = SKColor.whiteColor()
        healthLabel.position = CGPoint(x: 25, y: display.size.height / 2 - 25)
        healthLabel.horizontalAlignmentMode = .Left
        healthLabel.zPosition = 15
        
        // Power Up Health Hearts
        powerUps = SKSpriteNode(imageNamed: "life_power_up_1")
        powerUps.zPosition = 100
        powerUps.size = CGSize(width: 75, height: 75)
        powerUps.position = CGPoint(x: 75, y: display.size.height / 2 - 75)
        powerUps.name = "PowerUp"
        
        // Label to let user know the count of power ups
        powerUpLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        powerUpLabel.zPosition = 100
        powerUpCount = 0
        powerUpLabel.color = UIColor.redColor()
        powerUpLabel.colorBlendFactor = 1.0
        powerUpLabel.text = " X \(powerUpCount)"
        powerUpLabel.fontSize = powerUps.size.height
        powerUpLabel.position = CGPoint(x: powerUps.frame.width + 125, y: display.size.height / 2 - 105)
        
        // Score label
        scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        score = 0
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = display.size.height
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.position = CGPoint(x: display.size.width - 30, y: display.size.height / 2 - 25)
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.zPosition = 15
        
        // Coin Image
        coinImage = SKSpriteNode(imageNamed: "Coin_1")
        coinImage.zPosition = 200
        coinImage.size = CGSize(width: 75, height: 75)
        coinImage.position = CGPoint(x: self.size.width - 200, y: display.size.height / 2 - 85)
        coinImage.name = "Coin"
        
        // Label to let user know the count of coins collected
        coinCountLbl = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        coinCountLbl.zPosition = 200
        coinCount = 0
        coinCountLbl.color = UIColor.yellowColor()
        coinCountLbl.colorBlendFactor = 1.0
        coinCountLbl.text = " X \(coinCount)"
        coinCountLbl.fontSize = powerUps.size.height
        coinCountLbl.position = CGPoint(x: self.frame.width - 75, y: display.size.height / 2 - 115)
        
        self.addChild(display)
        pauseNode.removeFromParent()
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

    // Sets the initial values for our variables
//    func initializeValues(){
//        
//        self.removeAllChildren()
//        
//        gameOverLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
//        gameOverLabel!.text = "GAME OVER"
//        gameOverLabel!.fontSize = 80
//        gameOverLabel!.fontColor = SKColor.blackColor()
//        gameOverLabel!.position = CGPoint(x: CGRectGetMinX(self.frame)/2, y: (CGRectGetMinY(self.frame)/2))
//        
//        gameOverLabel?.removeFromParent()
//        self.addChild(gameOverLabel!)
//    }
//    
//    // Check if the game is over by looking at our health
//    // Shows game over screen if needed
//    func checkIfGameIsOver(){
//        if (health <= 0 && gameOver == false){
//            self.removeAllChildren()
//            showGameOverScreen()
//            gameOver = true
//        }
//    }
//    
//    // Displays the game over screen
//    func showGameOverScreen(){
//        gameOverLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
//        gameOverLabel!.text = "Game Over!  Score: \(score)"
//        gameOverLabel!.fontColor = SKColor.redColor()
//        gameOverLabel!.fontSize = 65
//        gameOverLabel!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
//        
//        gameOverLabel?.removeFromParent()
//        self.addChild(gameOverLabel!)
//    }
    
    func holdGame() {
        
        self.scene!.view?.paused = false
        
        // Stop movement, fade out, move to center, fade in
        player.removeAllActions()
        self.player.runAction(SKAction.fadeOutWithDuration(1) , completion: {
            self.player.position = CGPointMake(self.size.width / 2, self.size.height / 2)
            self.player.runAction(SKAction.fadeInWithDuration(1), completion: {
                self.scene!.view?.paused = true
            })
        })
    }

    // Add sound to other classes to avoid AV being nil and crashing
    func playSound(soundVariable: SKAction) {
        runAction(soundVariable)
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
}
