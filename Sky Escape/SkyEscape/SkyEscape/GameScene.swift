//
//  GameScene.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/3/16.
//  Copyright (c) 2016 Full Sail. All rights reserved.
//

import SpriteKit
//import AVFoundation
//import CoreMotion


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
    static let All          : UInt32 = UInt32.max // all nodes
}

// Global emitter objects
var smokeTrail = SKEmitterNode(fileNamed: "SmokeTrail")!
var smoke = SKEmitterNode(fileNamed: "Smoke")!
var explode = SKEmitterNode(fileNamed: "Explode")!
var explosion = SKEmitterNode(fileNamed: "FireExplosion")!

// Global sound
// Audio nodes for sound effects and music
//var audioPlayer = AVAudioPlayer()
//var player = AVAudioEngine()
//var audioFile = AVAudioFile()
//var audioPlayerNode = AVAudioPlayerNode()
var airplaneFlyBySound = SKAudioNode(fileNamed: "airplaneFlyBy")
//var airplaneP51Sound = SKAudioNode(fileNamed: "airplanep51")
//var bGCannonsSound = SKAudioNode(fileNamed: "bGCannons")
var bgMusic = SKAudioNode(fileNamed: "bgMusic")
var biplaneFlyingSound = SKAudioNode(fileNamed: "biplaneFlying")
//var bombSound = SKAudioNode(fileNamed: "bombaway")
//var coinSound = SKAudioNode(fileNamed: "coin")
//var crashSound = SKAudioNode(fileNamed: "crash")
var gunfireSound = SKAudioNode(fileNamed: "gunfire")
//var mortarSound = SKAudioNode(fileNamed: "mortar")
var mp5GunSound = SKAudioNode(fileNamed: "mp5Gun")
//var planeMGunSound = SKAudioNode(fileNamed: "planeMachineGun")
//var powerUpSound = SKAudioNode(fileNamed: "powerUp")
//var propSound = SKAudioNode(fileNamed: "prop")
//var rocketSound = SKAudioNode(fileNamed: "rocket")
//var shootSound = SKAudioNode(fileNamed: "shoot")
//var skyBoomSound = SKAudioNode(fileNamed: "skyBoom")
//var startGameSound = SKAudioNode(fileNamed: "startGame")
//var tankSound = SKAudioNode(fileNamed: "tank")
//var tankFiringSound = SKAudioNode(fileNamed: "tankFiring")

// HUD global variables
let maxHealth = 100
let healthBarWidth: CGFloat = 170
let healthBarHeight: CGFloat = 10
let playerHealthBar = SKSpriteNode()

let darkenOpacity: CGFloat = 0.5
let darkenDuration: CFTimeInterval = 2

var enemyNum = 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    /************************** Property constants declared ************/
    // MARK: - Property constants declared
    
    // Location for touch screen
    var touchLocation = CGPointZero
    
    // Image atlas's for animation
//    var animation = SKAction()
//    var animationFrames = [SKTexture]()
    
    // Enemy animation setup class
    
    // Animation setup class
    let node = SKNode()
    var player = SKSpriteNode()
    
    // Player's weapons
    var bullet = SKSpriteNode(imageNamed: "fireBullet")
    var bombs = SKSpriteNode(imageNamed: "bomb")
    var bomber = SKSpriteNode(imageNamed: "bomber")
    var wingman = SKSpriteNode(imageNamed: "wingman")
    
    // My backgrounds
    var myBackground = SKSpriteNode()
    var midground = SKSpriteNode()
    var foreground = SKSpriteNode()
    
    // Enemy planes - static, straight
    var enemy = SKSpriteNode()
    var myEnemy1 = SKSpriteNode()
    var myEnemy2 = SKSpriteNode()
    var enemyArray = [SKTexture]()
    var randomEnemy = SKSpriteNode()
    var enemyFire = SKSpriteNode(imageNamed: "bullet")
    
    // Enemy planes - random pathway
    var fokker1: SKSpriteNode!
    var fokker2: SKSpriteNode!
    var animationArray = [[SKTexture]]()
    var animationArray1 = [SKTexture]()
    var animationArray2 = [SKTexture]()
    var randomFokker: SKSpriteNode!
    
    // Sky nodes
    var powerUp = SKSpriteNode()
    var coins = SKSpriteNode()
    
    // Atlas group
    var enemyArrayAtlas = SKTextureAtlas(named: "EnemyArray")
    var enemy1Atlas = SKTextureAtlas(named: "Enemy1Attack")
    var enemy2Atlas = SKTextureAtlas(named: "Enemy2Attack")
    var enemyDie1Atlas = SKTextureAtlas(named: "Enemy1Die")
    var enemyDie2Atlas = SKTextureAtlas(named: "Enemy2Die")
    var soldierShootAtlas = SKTextureAtlas(named: "SoldierShoot")
    var soldierWalkAtlas = SKTextureAtlas(named: "SoldierWalk")
    var turretAtlas = SKTextureAtlas(named: "Turret")
    var tankForwardAtlas = SKTextureAtlas(named: "TankForward")
    var tankAttackAtlas = SKTextureAtlas(named: "TankAttack")
    var powerUpsAtlas = SKTextureAtlas(named: "PowerUps")
    var coinsAtlas = SKTextureAtlas(named: "Coins")
    
    // Timers for spawn / interval / delays
    var timer = NSTimer()
    var wingTimer = NSTimer()
    var coinsTimer = NSTimer()
    var enemyTimer = NSTimer()
    var enemyShoots = NSTimer()
    var cloudTimer  = NSTimer()
    var explosions  = NSTimer()
    var powerUpTimer = NSTimer()
    
    // Game metering GUI
    var score = 0
    var powerUpCount = 0
    var coinCount = 0
    var health = 20
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
    }
    
    
    /*********************************** touchesBegan Function **************************************/
    // MARK: - touchesBegan
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if gameStarted == false {
            
            gameStarted = true
        
            
            touchLocation = touches.first!.locationInNode(self)
            
            for touch: AnyObject in touches {
                let location = (touch as! UITouch).locationInNode(self)
                
                /* Allows to tap on screen and plane will present
                 at that axis and shoot at point touched */
                
                if let myPlaneNode = SKScene(fileNamed: "Player")!.childNodeWithName("player") as? SKSpriteNode {
                    player = myPlaneNode
                    
                    player.position.y = location.y // Allows a tap to touch on the y axis
                    player.position.x = location.x // Allows a tap to touch on the x axis
                    
                }
                
                // Call function when play sound
//                let startGameSound = SKAction.playSoundFileNamed("startGame", waitForCompletion: false)
//                playSound(startGameSound)

                
                // Added HUD with PAUSE
                createHUD() /* function opens up the HUD and makes the button accessible
                 also, has displays for health and score. */
                
                let node = self.nodeAtPoint(location)
                if (node.name == "PauseButton") || (node.name == "PauseButtonContainer") {
                    showPauseAlert()
                }
                
                // Counts number of enemies
                if let theName = self.nodeAtPoint(location).name {
                    if theName == "Enemy" {
                        self.removeChildrenInArray([self.nodeAtPoint(location)])
                        score += 1
                    }
                }
                
                if (gameOver == true) { // If goal is hit - game is completed
                    checkIfGameIsOver()
                }
                
                
                /******************************** Spawning Nodes *********************************/
                // MARK: - Spawning
                
                // Call function to setup player's plane
                setupPlayer()
                fireBullets()
                self.addChild(playerHealthBar)
                
                // Call func to spawn enemy planes - the enemy squadrons
//                setupEnemyFokkers()
                
//                setupTurret()
//                setupSoldiers()
//                setupTank()
//                spawnPowerUps()
//                spawnCoins()
                
                
                /********************************* Spawn Timers *********************************/
                // MARK: - Spawn Timers
                
                // Spawning bullets timer call
//                timer = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: #selector(GameScene.setupEnemyFokkers), userInfo: nil, repeats: true)
                
                // Spawning wingmen timer call
                wingTimer = NSTimer.scheduledTimerWithTimeInterval(12.0, target: self, selector: #selector(GameScene.spawnWingman), userInfo: nil, repeats: true)
                
                // Spawning wingmen timer call
                wingTimer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: #selector(GameScene.spawnBomber), userInfo: nil, repeats: true)
                
                // Spawning enemies timer call
                enemyTimer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(GameScene.spawnEnemyPlanes), userInfo: nil, repeats: true)
                
                // Spawning enemy fire timer call
                enemyShoots = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(GameScene.spawnEnemyFire), userInfo: nil, repeats: true)
                
                // Put planes on a linear interpolation path
                runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(setupEnemyFokkers),
                    SKAction.waitForDuration(10.0)
                    ])
                    ))
                
                // Set enemy tank spawn intervals
//                coinsTimer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: #selector(GameScene.spawnCoins), userInfo: nil, repeats: true)
                
                // Spawning enemy fire timer call
//                powerUpTimer = NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: #selector(GameScene.spawnPowerUps), userInfo: nil, repeats: true)
                
                // Cloud sound timer will for 12 sec and stop, then run again
//                cloudTimer = NSTimer.scheduledTimerWithTimeInterval(24.0, target: self, selector: #selector(GameScene.rainBadCloud), userInfo: nil, repeats: true)

                
                /**************************** Preloading Sound & Music ****************************/
                // MARK: - Spawning
                                
                // After import AVFoundation, needs do,catch statement to preload sound so no delay
//                func setUpEngine() {
//                
//                    do {
//                        let sounds = ["airplaneFlyBy", "airplanep51", "bGCannons", "bgMusic", "biplaneFlying", "bombaway", "coin", "crash",  "gunfire", "mortar", "mp5Gun", "planeMachineGun", "powerUp", "prop", "rocket", "shoot", "skyBoom", "startGame", "tank", "tankFiring"]
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
//                }
                
                // Adds background sound to game
//                bgMusic = SKAudioNode(fileNamed: "bgMusic")
//                bgMusic.runAction(SKAction.play())
//                bgMusic.autoplayLooped = true
//                
//                bgMusic.removeFromParent()
//                self.addChild(bgMusic)
//                
//                biplaneFlyingSound = SKAudioNode(fileNamed: "biplaneFlying")
//                biplaneFlyingSound.runAction(SKAction.play())
//                biplaneFlyingSound.autoplayLooped = true
//                
//                biplaneFlyingSound.removeFromParent()
//                self.addChild(biplaneFlyingSound)
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
        // Each node will collide with the equalled item due to bit mask
        
        // Drop bombs when touch ends...for now - Looking to do double tap or button!
        fireBombs()
    }
    
    
    /*********************************** Update Function *****************************************/
    // MARK: - Update Function
    
    // Update for animations and positions
    override func update(currentTime: NSTimeInterval) {
        
        if !self.gamePaused {
            holdGame()
            self.scene!.view?.paused = false
        }
        
//        bgMusic.runAction(SKAction.play())
        
        // Move backgrounds
        moveBackground()
        moveMidground()
        moveForeground()
        
        bullet.position = CGPoint(x: player.position.x - player.size.width / 2 + 20, y: player.position.y + 5)
        
        // Plane's smoketrail will follow it as updating occurs
        smokeTrail.position = CGPoint(x: player.position.x - 85, y: player.position.y - 10)
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
        if(health <= 3) {
            healthLabel.fontColor = SKColor.redColor()
        }
    }
    

    /********************************* Background Functions *********************************/
    // MARK: - Background Functions
    
    // Adding scrolling background
    func createBackground() {
        
        let myBackground = SKTexture(imageNamed: "clouds")
        
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
        
        let midground1 = SKTexture(imageNamed: "mountains")
       
        for i in 0...2 {
            let ground = SKSpriteNode(texture: midground1)
            ground.name = "Midground"
            ground.zPosition = 20
            ground.position = CGPoint(x: (midground1.size().width / 2.0 + (midground1.size().width * CGFloat(i))), y: midground1.size().height / 2)
            
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
        
        let foreground = SKTexture(imageNamed: "lonelytree")
        
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
            ground.physicsBody?.collisionBitMask = PhysicsCategory.MyPlane4
            ground.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
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
    // MARK: - Spawning Functions

    // From the Player class
    func setupPlayer() {
        
        // Initial position of my plane
        player = (SKScene(fileNamed: "Player")!.childNodeWithName("player") as? SKSpriteNode)!
        player.position = CGPoint(x: self.size.width / 6, y: self.size.height / 2)
        player.setScale(0.7)
        player.zPosition = 100
        
        player.removeFromParent()
        addChild(player)
        
        // Add physics to my plane
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.categoryBitMask = PhysicsCategory.MyPlane4
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.dynamic = false
    }
    
    func fireBullets() {
        
        bullet = SKSpriteNode(imageNamed: "fireBullet")
        bullet.name = "firebullet"
        bullet.setScale(0.8)
        bullet.zPosition = 80
        
        bullet.removeFromParent()
        addChild(bullet)
        
        // Shoot em up!
        let action = SKAction.moveToX(self.size.width + 150, duration: 1.5)
        let actionDone = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([action, actionDone]))
        
        // Add gun sound
//        shootSound = SKAudioNode(fileNamed: "shoot")
//        shootSound.runAction(SKAction.play())
//        shootSound.autoplayLooped = false
//        
//        shootSound.removeFromParent()
//        self.addChild(shootSound)
    }

    func fireBombs() {
        
        bombs = SKSpriteNode(imageNamed: "bomb")
        bombs.name = "bomb"
        bombs.position = CGPoint(x: player.position.x, y: player.position.y)
        bombs.setScale(0.1)
        bombs.zPosition = 80
        
        bombs.removeFromParent()
        addChild(bombs)
        
        // Add bomb physics
        bombs.physicsBody = SKPhysicsBody(rectangleOfSize: bombs.size)
        bombs.physicsBody?.categoryBitMask = PhysicsCategory.Bombs256
        bombs.physicsBody?.collisionBitMask = PhysicsCategory.None
        bombs.physicsBody?.allowsRotation = false
        bombs.physicsBody?.dynamic = false
        
        let moveBombAction = SKAction.moveToY(-100, duration: 2.0)
        let removeBombAction = SKAction.removeFromParent()
        bombs.runAction(SKAction.sequence([moveBombAction,removeBombAction]))
    
        // Add gun sound
//        bombSound = SKAudioNode(fileNamed: "bombaway")
//        bombSound.runAction(SKAction.play())
//        bombSound.autoplayLooped = false
        
//        bombSound.removeFromParent()
//        self.addChild(bombSound)
    }
    
    // Adding ally forces in background
    func spawnWingman() {
        
        // Alternate wingmen 1 of 2 passby's in the distance
        wingman = SKSpriteNode(imageNamed: "Fokker2")
        wingman.zPosition = 23
        wingman.setScale(0.3)
        
        // Calculate random spawn points for wingmen
        let random = CGFloat(arc4random_uniform(800) + 150)
        wingman.position = CGPoint(x: -self.size.width, y: random)
        
        wingman.removeFromParent()
        addChild(wingman) // Generate the random wingman
        
        // Move wingmen forward
        let action = SKAction.moveToX(self.size.width + 50, duration: 16.0)
        let actionDone = SKAction.removeFromParent()
        wingman.runAction(SKAction.sequence([action, actionDone]))
    }
    
    // Adding ally forces in background
    func spawnBomber() {
        
        // Alternate wingmen 2 of 2 passby's in the distance
        bomber = SKSpriteNode(imageNamed: "bomber")
        bomber.zPosition = 22
        bomber.setScale(0.3)
        
        // Calculate random spawn points for bomber
        let random = CGFloat(arc4random_uniform(700) + 250)
        bomber.position = CGPoint(x: -self.size.width, y: random)
        
        bomber.removeFromParent()
        addChild(bomber) // Generate the random wingman
        
        // Move bomber forward
        let action = SKAction.moveToX(self.size.width + 80, duration: 20.0)
        let actionDone = SKAction.removeFromParent()
        bomber.runAction(SKAction.sequence([action, actionDone]))
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

        randomEnemy.setScale(0.25)
        randomEnemy.zPosition = 90
        
        // Calculate random spawn points for air enemies
        let randomY = CGFloat(arc4random_uniform(700) + 250)
        randomEnemy.position = CGPoint(x: self.size.width, y: randomY)

        // Add enemies
        randomEnemy.removeFromParent()
        addChild(randomEnemy)
        
        // Body physics for enemy's planes
        randomEnemy.physicsBody = SKPhysicsBody(rectangleOfSize: randomEnemy.size)
        randomEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy8
        randomEnemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        randomEnemy.physicsBody?.dynamic = true

        // Move enemies forward
        let action = SKAction.moveToX(-260, duration: 4.0)
        let actionDone = SKAction.removeFromParent()
        randomEnemy.runAction(SKAction.sequence([action, actionDone]))
    
        // Add sound
//        airplaneFlyBySound = SKAudioNode(fileNamed: "airplaneFlyBy")
//        airplaneFlyBySound.runAction(SKAction.play())
//        airplaneFlyBySound.autoplayLooped = false
//        airplaneFlyBySound.removeFromParent()
//        self.addChild(airplaneFlyBySound)// Alternative sounds to choose from
        
        spawnEnemyFire()
    }
    
    // Setup special enemy fighters that move randomly
    func setupEnemyFokkers() {

        // Animation of first enemy random pathway plane
        if let fokker = SKScene(fileNamed: "EnemyPlanes")!.childNodeWithName("fokkerAttack1") as? SKSpriteNode {
            fokker1 = fokker
//        }
//        
//        // Animation of second enemy random pathway plane
//        if let enemyPlane2 = SKScene(fileNamed: "EnemyPlanes")!.childNodeWithName("fokkerAttack2") as? SKSpriteNode {
//            fokker2 = enemyPlane2
//        }

//        fokker1 = SKSpriteNode(imageNamed: "enemy1Attack")
//        fokker2 = SKSpriteNode(imageNamed: "enemy2Attack")
        
//        let planeEnemy = [fokker1, fokker2]
        
        // Generate a random index
//        let randomIndex = Int(arc4random_uniform(UInt32(planeEnemy.count)))
        
        // Get a random enemy
//        randomFokker = planeEnemy[randomIndex]
//        print(randomFokker.description)
        
        // Planes position off screen
        let actualY = CGFloat(arc4random_uniform(750) + 200)
        fokker1.position = CGPoint(x: self.size.width, y: actualY)
        fokker1.zPosition = 90
        
        fokker1.removeAllActions() // Used bc it is animated
//        fokker2.removeAllActions()
//        randomFokker.removeAllActions()
        self.addChild(fokker1) // Add enemy fokker plane to scene
        
        // Add Fokker physics
        fokker1.physicsBody = SKPhysicsBody(rectangleOfSize: fokker1.size)
        fokker1.name = "enemyFokker"
        fokker1.physicsBody?.categoryBitMask = PhysicsCategory.Enemy8
        fokker1.physicsBody?.collisionBitMask = PhysicsCategory.None
        fokker1.physicsBody?.allowsRotation = false
        fokker1.physicsBody?.dynamic = true
        
        // This time I will determine speed by velocity rather than time interval
        let actualDuration = random(min: 3.0, max: 8.0)
        
        // Create a path func for planes to randomly follow {
        let actionMove = SKAction.moveTo(CGPoint(x: -fokker1.size.width / 2, y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        fokker1.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        }
        spawnEnemyFire()
    }

    // Function to allow all enemy planes to get setup and fire
    func spawnEnemyFire() {
        
        enemyFire.name = "EnemyFire"
        enemyFire.setScale(0.2)
        enemyFire.zPosition = 100
        
        enemyFire.position = CGPointMake(randomEnemy.position.x - 75, randomEnemy.position.y)
        
        enemyFire.removeFromParent()
        self.addChild(enemyFire) // Generate enemy fire
        
        // Body physics of player's bullets
        enemyFire.physicsBody = SKPhysicsBody(rectangleOfSize: enemyFire.size)
        enemyFire.physicsBody?.categoryBitMask = PhysicsCategory.EnemyFire16
        enemyFire.physicsBody?.contactTestBitMask = PhysicsCategory.None
        enemyFire.physicsBody?.dynamic = false
        
        // Change attributes
        enemyFire.color = UIColor.yellowColor()
        enemyFire.colorBlendFactor = 1.0
        
        // Shoot em up!
        let action = SKAction.moveToX(-30, duration: 1.0)
        let actionDone = SKAction.removeFromParent()
        enemyFire.runAction(SKAction.sequence([action, actionDone]))
    }
    
//    func die1() {
//        
//        let enemyAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemy1Die")
//        
//        for i in 1...enemyAtlas.textureNames.count {
//            let myEnemy = "enemy1_death_\(i)"
//            enemyArray.append(SKTexture(imageNamed: myEnemy))
//        }
//        
//        // Add user's animated bi-plane
//        myEnemy1 = SKSpriteNode(imageNamed: enemyAtlas.textureNames[0])
//        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(enemyArray, timePerFrame: 0.1))
//        self.runAction(animation)
//    }
    
//    func die2() {
//        
//        let enemyAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemy2Die")
//        
//        for i in 1...enemyAtlas.textureNames.count {
//            let myEnemy = "enemy2_death_\(i)"
//            enemyArray.append(SKTexture(imageNamed: myEnemy))
//        }
//        
//        // Add user's animated bi-plane
//        myEnemy2 = SKSpriteNode(imageNamed: enemyAtlas.textureNames[0])
//        animation = SKAction.repeatActionForever( SKAction.animateWithTextures(enemyArray, timePerFrame: 0.1))
//        self.runAction(animation)
//    }
    
    // Spawn ground tank - it can't fly!! ;)
//    func setupTank() {
//        
//        tanks.position = CGPoint(x: self.size.width, y: self.size.height + 50)
//        
//        // Added tank physics
//        tanks.physicsBody = SKPhysicsBody(rectangleOfSize: tanks.size)
//        tanks.name = "Tanks"
//        tanks.physicsBody?.categoryBitMask = PhysicsCategory.Tanks8192
//        tanks.physicsBody?.collisionBitMask = PhysicsCategory.None
//        tanks.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4 | PhysicsCategory.MyBullets2 | PhysicsCategory.Enemy8 | PhysicsCategory.EnemyFire16
//        tanks.physicsBody?.affectedByGravity = false
//        tanks.physicsBody?.dynamic = true
//        
//        addChild(tanks) // Generate enemy tank
//        
//        // Add sound
//        tankSound = SKAudioNode(fileNamed: "tank")
//        tankSound.runAction(SKAction.play())
//        tankSound.autoplayLooped = false
//        tankSound.removeFromParent()
//        self.addChild(tankSound)
//    }

    // Spawn enemy tank missiles
//func spawnTankMissiles() {
//
//    // Spawning an enemy tank's anti-aircraft missiles
//    missiles = SKSpriteNode(imageNamed: "missile")
//    missiles.setScale(0.5)
//    missiles.zPosition = -9
//
//    missiles.position = CGPoint(x: tank.position.x, y: tank.position.y)
//
//    // Added missile physics
//    missiles.physicsBody = SKPhysicsBody(rectangleOfSize: missiles.size)
//    missiles.physicsBody?.affectedByGravity = false
//    missiles.physicsBody?.categoryBitMask = PhysicsCategory.Missiles128
//    missiles.physicsBody?.contactTestBitMask = PhysicsCategory.Player8 | PhysicsCategory.MyBullets2
//    missiles.physicsBody?.collisionBitMask = 128
//    missiles.physicsBody?.dynamic = false
//
//    // Shoot em up!
//    let action = SKAction.moveToY(self.size.height + 80, duration: 3.0)
//    let actionDone = SKAction.removeFromParent()
//    missiles.runAction(SKAction.sequence([action, actionDone]))
//
//    self.addChild(missiles) // Generate tank missile
//
//    // Add sound
//    tankFiringSound = SKAudioNode(fileNamed: "tankFiring")
//    tankFiringSound.runAction(SKAction.play())
//    tankFiringSound.autoplayLooped = false
//    
//        self.addChild(tankFiringSound)
//}

    // Spawn sky nodes
//    func skyExplosions() {
//        
//        // Sky explosions of a normal battle
//        explosion = SKEmitterNode(fileNamed: "FireExplosion")!
//        explosion.particleLifetime = 0.5
//        explosion.particleScale = 0.4
//        explosion.particleSpeed = 1.5
//        explosion.zPosition = 9
//        
//        let xPos = randomBetweenNumbers(0, secondNum: frame.width )
//        
//        // Sky bomb position on screen
//        explosion.position = CGPoint(x: xPos, y: self.frame.size.height * 0.25)
//        
//        self.addChild(explosion)
//        
//        // Physics for sky bomb
//        explosion.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
//        explosion.name = "SkyBomb"
//        explosion.physicsBody?.categoryBitMask = PhysicsCategory.SkyBombs512
//        explosion.physicsBody?.collisionBitMask = PhysicsCategory.None
//        explosion.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4 | PhysicsCategory.Enemy8
//        explosion.physicsBody?.dynamic = false
//        explosion.physicsBody?.affectedByGravity = false
//    
//        skyBoomSound = SKAudioNode(fileNamed: "skyBoom")
//        skyBoomSound.runAction(SKAction.play())
//        skyBoomSound.autoplayLooped = false
//        
//        skyBoomSound.removeFromParent()
//        self.addChild(skyBoomSound)
//        
        // Sky bomb spawn timer
//        runAction(SKAction.repeatActionForever(SKAction.sequence([
//            SKAction.runBlock(skyExplosions),
//            SKAction.waitForDuration(12.0)
//            ])
//            ))
//    }
    
    // Spawning coins
//    func spawnCoins() {
//        
//        // Loop to run through .png's for animation
//        for i in 1...coinsAtlas.textureNames.count {
//            let coins = "Coin_\(i)"
//            animationFrames.append(SKTexture(imageNamed: coins))
//        }
//        
//        // Add user's animated coins
//        skyCoins = SKSpriteNode(imageNamed: coinsAtlas.textureNames[0])
//        
//        let xPos = randomBetweenNumbers(0, secondNum: frame.width )
//        
//        // Star position off screen
//        skyCoins.position = CGPoint(x: xPos, y: self.frame.size.height * 0.25)
//        skyCoins.setScale(1.0)
//        skyCoins.zPosition = 110
//        
//        self.addChild(skyCoins)
//        
//        // Added skyCoins physics
//        skyCoins.physicsBody = SKPhysicsBody(edgeLoopFromRect: powerUp.frame)
//        skyCoins.physicsBody?.categoryBitMask = PhysicsCategory.Coins128
//        skyCoins.physicsBody?.collisionBitMask = PhysicsCategory.None
//        skyCoins.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
//        skyCoins.physicsBody?.dynamic = false
//        skyCoins.physicsBody?.affectedByGravity = false
//    
        // Add sound
//        coinSound = SKAudioNode(fileNamed: "coin")
//        coinSound.runAction(SKAction.play())
//        coinSound.autoplayLooped = false
//        coinSound.removeFromParent()
//        self.addChild(coinSound)
//        
        // Coin spawn timer
//        runAction(SKAction.repeatActionForever(SKAction.sequence([
//            SKAction.runBlock(spawnCoins),
//            SKAction.waitForDuration(12.0)
//            ])
//            ))
//    }
//    
    // Spawning a bonus star
//    func spawnPowerUps() {
//        
//        // Loop to run through .png's for animation
//        for i in 1...powerUpsAtlas.textureNames.count {
//            let powerUp = "life_power_up_\(i)"
//            animationFrames.append(SKTexture(imageNamed: powerUp))
//        }
//        
//        // Add user's animated powerUp
//        powerUp = SKSpriteNode(imageNamed: powerUpsAtlas.textureNames[0])
//        
//        let xPos = randomBetweenNumbers(0, secondNum: frame.width )
//        
//        // Star position off screen
//        powerUp.position = CGPoint(x: xPos, y: self.frame.size.height * 0.25)
//        powerUp.setScale(0.9)
//        powerUp.zPosition = 11
//        
//        powerUp.removeFromParent()
//        self.addChild(powerUp)
//        
//        // Added star's physics
//        powerUp.physicsBody = SKPhysicsBody(edgeLoopFromRect: powerUp.frame)
//        powerUp.physicsBody?.categoryBitMask = PhysicsCategory.PowerUp64
//        powerUp.physicsBody?.collisionBitMask = PhysicsCategory.None
//        powerUp.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
//        powerUp.physicsBody?.dynamic = false
//        powerUp.physicsBody?.affectedByGravity = false
//    
        // Add sound
//        powerUpSound = SKAudioNode(fileNamed: "powerUp")
//        powerUpSound.runAction(SKAction.play())
//        powerUpSound.autoplayLooped = false
//        powerUpSound.removeFromParent()
//        self.addChild(powerUpSound)
//        
        // Put bad cloud on a linear interpolation path
//        runAction(SKAction.repeatActionForever(SKAction.sequence([
//            SKAction.runBlock(spawnPowerUps),
//            SKAction.waitForDuration(25.0)
//            ])
//            ))
//    }
    
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
    
    
    /*************************************** Pause ******************************************/
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
//        powerUp = SKSpriteNode(imageNamed: "life_power_up_1")
//        powerUp.zPosition = 100
//        powerUp.size = CGSize(width: 75, height: 75)
//        powerUp.position = CGPoint(x: 75, y: display.size.height / 2 - 75)
//        powerUp.name = "PowerUp"
        
        // Label to let user know the count of power ups
        powerUpLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        powerUpLabel.zPosition = 100
//        powerUpCount = 0
        powerUpLabel.color = UIColor.redColor()
        powerUpLabel.colorBlendFactor = 1.0
        powerUpLabel.text = " X \(powerUpCount)"
//        powerUpLabel.fontSize = powerUp.size.height
//        powerUpLabel.position = CGPoint(x: powerUp.frame.width + 125, y: display.size.height / 2 - 105)
        
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
//        coinCountLbl.fontSize = powerUp.size.height
        coinCountLbl.position = CGPoint(x: self.frame.width - 75, y: display.size.height / 2 - 115)
        
        self.addChild(display)
        pauseNode.removeFromParent()
        display.addChild(pauseNode)
        display.addChild(pauseButton)
        display.addChild(healthLabel)
//        display.addChild(powerUp)
        display.addChild(powerUpLabel)
        display.addChild(scoreLabel)
        display.addChild(coinImage)
        display.addChild(coinCountLbl)
    }
    
    // Check if the game is over by looking at our health
    // Shows game over screen if needed
    func checkIfGameIsOver(){
        if (health <= 0 && gameOver == false){
            self.removeAllChildren()
            showGameOverScreen()
            gameOver = true
        }
    }
    
    // Displays the game over screen
    func showGameOverScreen(){
        gameOverLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        gameOverLabel!.text = "Game Over!  Score: \(score)"
        gameOverLabel!.fontColor = SKColor.redColor()
        gameOverLabel!.fontSize = 65
        gameOverLabel!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame));
        self.addChild(gameOverLabel!)
    }
    
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
    
    /********************************** Simulating Physics ***************************************/
    // MARK: - Simulate Physics
    
    override func didSimulatePhysics() {
        
    }
    
    
    /************************************ didBeginContact *****************************************/
    // MARK: - didBeginContact
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("PLANE HAS CONTACT")
        
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
            
            //            crashSound = SKAudioNode(fileNamed: "crash")
            //            crashSound.runAction(SKAction.play())
            //            crashSound.autoplayLooped = false
            //
            //            crashSound.removeFromParent()
            //            self.addChild(crashSound)
        }
            
            // MyBullet VS
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
            
            //            crashSound.runAction(SKAction.play())
            //            crashSound.autoplayLooped = false
            //            crashSound.removeFromParent()
            
            //            self.addChild(crashSound)
            
            // Hitting an the enemy adds score and health
            //            score += 10
            //            health += 2
            //            playerHP = max(0, health + 2)
        }
            //        else if ((contactBody1.categoryBitMask == 2) && (contactBody2.categoryBitMask == 64)) {
            //            explode = SKEmitterNode(fileNamed: "Explode")!
            //            explode.position = (contactBody2.node?.position)!
            //
            //            explode.removeFromParent()
            //            self.addChild(explode)
            //
            //            contactBody1.node?.removeFromParent()
            //            contactBody2.node?.removeFromParent()
            //
            //            // Calling pre-loaded sound to the star hits
            //            powerUpSound = SKAudioNode(fileNamed: "powerUp")
            //            powerUpSound.runAction(SKAction.play())
            //            powerUpSound.autoplayLooped = false
            //
            //            powerUpSound.removeFromParent()
            //            self.addChild(powerUpSound)
            //
            //            // Points per star added to score and 1 health
            //            score += 5
            //            health += 10
            //            playerHP = max(0, health + 10)
            //            powerUpCount += 1
            //        }
            //        else if ((contactBody1.categoryBitMask == 2) && (contactBody2.categoryBitMask == 128)) {
            //            explode = SKEmitterNode(fileNamed: "Explode")!
            //            explode.position = (contactBody2.node?.position)!
            //
            //            explode.removeFromParent()
            //            self.addChild(explode)
            //
            //            contactBody1.node?.removeFromParent()
            //            contactBody2.node?.removeFromParent()
            //
            //            // Calling pre-loaded sound to the star hits
            //            coinSound = SKAudioNode(fileNamed: "coin")
            //            coinSound.runAction(SKAction.play())
            //            coinSound.autoplayLooped = false
            //            coinSound.removeFromParent()
            //            self.addChild(coinSound)
            //
            //            // Points per star added to score and 1 health
            //            score += 5
            //            coinCount += 1
            //        }
            
            // MyPlane VS
        else if((contactBody1.categoryBitMask == 4) && (contactBody2.categoryBitMask == 8)) {
            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
            smoke = SKEmitterNode(fileNamed: "Smoke")!
            
            self.addChild(explosion)
            self.addChild(smoke)
            
            explosion.position = contactBody2.node!.position
            smoke.position = contactBody2.node!.position
            
            runAction(SKAction.waitForDuration(2), completion: { explosion.removeFromParent() })
            runAction(SKAction.waitForDuration(3), completion: { smoke.removeFromParent() })
            
            contactBody2.node!.removeFromParent()
            
            // Add explosion sound
            //            crashSound = SKAudioNode(fileNamed: "crash")
            //            crashSound.runAction(SKAction.play())
            //            crashSound.autoplayLooped = false
            //
            //            crashSound.removeFromParent()
            //            self.addChild(crashSound)
            
            // Configure points
            //            health -= 10
            //            score += 5
            //            playerHP = max(0, health - 10)
        }
        //        else if ((contactBody1.categoryBitMask == 4) && (contactBody2.categoryBitMask == 16)) {
        //            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
        //
        //            explosion.position = contactBody1.node!.position
        //            self.addChild(explosion)
        //
        //            contactBody2.node!.removeFromParent()
        //
        //            crashSound = SKAudioNode(fileNamed: "crash")
        //            crashSound.runAction(SKAction.play())
        //            crashSound.autoplayLooped = false
        //
        //            crashSound.removeFromParent()
        //            self.addChild(crashSound)
        //
        //            health -= 5
        //            playerHP = max(0, health - 5)
        //        }
        //        else if ((contactBody1.categoryBitMask == 4) && (contactBody2.categoryBitMask == 64)) {
        //            explode = SKEmitterNode(fileNamed: "Explode")!
        //            explode.position = contactBody2.node!.position
        //
        //            self.addChild(explode)
        //
        //            contactBody2.node!.removeFromParent()
        //
        //            // Calling pre-loaded sound to the star hits
        //            powerUpSound = SKAudioNode(fileNamed: "powerUp")
        //            powerUpSound.runAction(SKAction.play())
        //            powerUpSound.autoplayLooped = false
        //
        //            powerUpSound.removeFromParent()
        //            self.addChild(powerUpSound)
        //
        //            // Points per star added to score and health
        //            score += 5
        //            health += 10
        //            powerUpCount += 1
        //            playerHP = max(0, health + 10)
        //        }
        //        else if ((contactBody1.categoryBitMask == 4) && (contactBody2.categoryBitMask == 512)) {
        //            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
        //            smoke = SKEmitterNode(fileNamed: "Smoke")!
        //
        //            explosion.position = contactBody1.node!.position
        //            smoke.position = contactBody1.node!.position
        //
        //            explosion.removeFromParent()
        //            smoke.removeFromParent()
        //            self.addChild(explosion)
        //            self.addChild(smoke)
        //
        //            crashSound = SKAudioNode(fileNamed: "crash")
        //            crashSound.runAction(SKAction.play())
        //            crashSound.autoplayLooped = false
        //            crashSound.removeFromParent()
        //            self.addChild(crashSound)
        //
        //            // Sky bomb hits us - we lose health
        //            health -= 10
        //            playerHP = max(0, health - 10)
        //        }
        //            
        //        // VS Enemy
        //        else if ((contactBody1.categoryBitMask == 8) && (contactBody2.categoryBitMask == 512)) {
        //            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
        //            smoke = SKEmitterNode(fileNamed: "Smoke")!
        //            
        //            explosion.position = contactBody1.node!.position
        //            smoke.position = contactBody1.node!.position
        //            
        //            explosion.removeFromParent()
        //            smoke.removeFromParent()
        //            self.addChild(explosion)
        //            self.addChild(smoke)
        //            
        //            contactBody1.node!.removeFromParent()
        //            
        //            crashSound = SKAudioNode(fileNamed: "crash")
        //            crashSound.runAction(SKAction.play())
        //            crashSound.autoplayLooped = false
        //            
        //            crashSound.removeFromParent()
        //            self.addChild(crashSound)
        //            
        //            // Sky bomb hits enemy - we get points
        //            score += 3
        //        }
    }
    
    // Add sound to other classes to avoid AV being nil and crashing
    //    func playSound(soundVariable: SKAction) {
    //        runAction(soundVariable)
    //    }

    
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


// Additional code not used:

// Spawn bullets for player's plane
//    func spawnBullets() {
//
//        bullets = SKSpriteNode(imageNamed: "fireBullet")
//        bullets.name = "firebullet"
//        bullets.position = CGPoint(x: myPlane.position.x, y: myPlane.position.y + myPlane.size.height / 2)
//        bullets.setScale(0.8)
//        bullets.zPosition = 80
//
//        runAction(SKAction.playSoundFileNamed("shoot", waitForCompletion: true))
//
//        addChild(bullets)
//
//        bullets.physicsBody = SKPhysicsBody(rectangleOfSize: bullets.size)
//        bullets.physicsBody!.categoryBitMask = PhysicsCategory.MyBullets2
//        bullets.physicsBody!.collisionBitMask = PhysicsCategory.None
//        bullets.physicsBody!.dynamic = true
//        bullets.physicsBody!.affectedByGravity = false
//
//        // Shoot em up!
//        let action = SKAction.moveToX(size.width + bullets.size.width, duration: 1.5)
//        let actionDone = SKAction.removeFromParent()
//        bullets.runAction(SKAction.sequence([action, actionDone]))
//
//        // Add gun sound
//        gunfireSound = SKAudioNode(fileNamed: "gunfire")
//        gunfireSound.runAction(SKAction.play())
//        gunfireSound.autoplayLooped = false
//
//        gunfireSound.removeFromParent()
//        self.addChild(gunfireSound)
//    }

// Spawn bullets for player's plane
//    func setupBombs() {
//
////        bombs = SKSpriteNode(imageNamed: "bomb")
//        bombs.name = "bomb"
//        bombs.position = CGPoint(x: myPlane.position.x, y: myPlane.position.y + myPlane.size.height / 2)
//        bombs.setScale(0.2)
//        bombs.zPosition = 80
//
////        runAction(SKAction.playSoundFileNamed("bombaway", waitForCompletion: true))
//
//        self.addChild(bombs)
//
//        bombs.physicsBody = SKPhysicsBody(rectangleOfSize: bullets.size)
//        bombs.physicsBody!.categoryBitMask = PhysicsCategory.Bombs1024
//        bombs.physicsBody!.collisionBitMask = PhysicsCategory.None
//        bombs.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy8
//        bombs.physicsBody!.dynamic = true
//        bombs.physicsBody!.affectedByGravity = false
//
//        // Add bomb sound
////        bombSound = SKAudioNode(fileNamed: "bombaway")
////        bombSound.runAction(SKAction.play())
////        bombSound.autoplayLooped = false
////
////        bombSound.removeFromParent()
////        self.addChild(bombSound)
//    }

//    func spawnEnemyFire() {
//        enemyFire = SKSpriteNode(imageNamed: "bullet")
//        enemyFire.setScale(0.1)
//        enemyFire.zPosition = -5
//
//        enemyFire.position = CGPointMake(randomEnemy.position.x - 75, randomEnemy.position.y)
//
//        self.addChild(enemyFire) // Generate enemy fire
//
//        // Body physics of player's bullets
//        enemyFire.physicsBody = SKPhysicsBody(rectangleOfSize: enemyFire.size)
//        enemyFire.name = "EnemyFire"
//        enemyFire.physicsBody?.categoryBitMask = PhysicsCategory.EnemyFire16
//        enemyFire.physicsBody?.collisionBitMask = PhysicsCategory.None
//        enemyFire.physicsBody?.dynamic = false
//        enemyFire.physicsBody?.affectedByGravity = false
//
//        // Change attributes
//        enemyFire.color = UIColor.yellowColor()
//        enemyFire.colorBlendFactor = 1.0
//
//        // Shoot em up!
//        let action = SKAction.moveToX(-30, duration: 1.2)
//        let actionDone = SKAction.removeFromParent()
//        enemyFire.runAction(SKAction.sequence([action, actionDone]))
//
//        // Add gun sound
//        mp5GunSound = SKAudioNode(fileNamed: "mp5Gun")
//        mp5GunSound.runAction(SKAction.play())
//        mp5GunSound.autoplayLooped = false
//        mp5GunSound.removeFromParent()
//        self.addChild(mp5GunSound)
//    }



