//
//  GameScene.swift
//  SkyEscape
//
//  Created by Allen Boynton on 8/3/16.
//  Copyright (c) 2016 Full Sail. All rights reserved.
//

import SpriteKit
import AVFoundation


// Binary connections for collision and colliding
struct PhysicsCategory {
    static let None       : UInt32 = 0   // 0
    static let Ground1    : UInt32 = 1   // 0x1 << 0
    static let MyBullets2 : UInt32 = 2   // 0x1 << 1
    static let MyPlane4   : UInt32 = 4   // 0x1 << 2
    static let Enemy8     : UInt32 = 8   // 0x1 << 3
    static let EnemyFire16: UInt32 = 16  // 0x1 << 4
    static let Cloud32    : UInt32 = 32  // 0x1 << 5
    static let PowerUp64  : UInt32 = 64  // 0x1 << 6
    static let Coins128   : UInt32 = 128 // 0x1 << 7
    static let Rain256    : UInt32 = 256 // 0x1 << 8
    static let SkyBombs512: UInt32 = 512 // 0x1 << 9
    static let All        : UInt32 = UInt32.max // all nodes
}
    
// Global emitter objects
var gunfire = SKEmitterNode(fileNamed: "Gunfire")!
var smoke = SKEmitterNode(fileNamed: "Smoke")!
var explode = SKEmitterNode(fileNamed: "Explode")!
var explosion = SKEmitterNode(fileNamed: "FireExplosion")!
var rain = SKEmitterNode(fileNamed: "Rain")

//// Global sound
//// Audio nodes for sound effects and music
//var audioPlayer = AVAudioPlayer()
//var player = AVAudioEngine()
//var audioFile = AVAudioFile()
//var audioPlayerNode = AVAudioPlayerNode()
//var bgMusic = SKAudioNode()
//var startGameSound = SKAudioNode()
//var biplaneFlyingSound = SKAudioNode()
//var gunfireSound = SKAudioNode()
//var coinSound = SKAudioNode()
//var powerUpSound = SKAudioNode()
//var skyBoomSound = SKAudioNode()
//var crashSound = SKAudioNode()
//var propSound = SKAudioNode()
//var planesFightSound = SKAudioNode()
//var bGCannonsSound = SKAudioNode()
//var planeMGunSound = SKAudioNode()
//var mortarSound = SKAudioNode()
//var airplaneFlyBySound = SKAudioNode()
//var airplaneP51Sound = SKAudioNode()
//var mp5GunSound = SKAudioNode()


// HUD global variables
let maxHealth = 100
let healthBarWidth: CGFloat = 175
let healthBarHeight: CGFloat = 10
let playerHealthBar = SKSpriteNode()

let darkenOpacity: CGFloat = 0.5
let darkenDuration: CFTimeInterval = 2

var enemyNum = 1

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Preloaded sound class
    let sound: Sounds = Sounds()
    
    // Background setup class
    let background: Backgrounds = Backgrounds()
    
    // Property constants declared
    let player: Player = Player() // myPlane animated
    
    // Enemy class
    let skyEnemy: SkyEnemy = SkyEnemy()
    
    
    // Location for touch screen
    var touchLocation = CGPointZero
    
//    // Main background
//    var myBackground = SKSpriteNode()
//    
//    // Mid background
//    var midground = SKSpriteNode()
//    
//    // Foreground
//    var foreground = SKSpriteNode()
    
    // MyPlane animation setup
    var node = SKNode()
//    var myPlane = SKSpriteNode()
//    var planeArray = [SKTexture]()
//    
//    // Image atlas's for animation
//    var animation = SKAction()
    var animationFrames = [SKTexture]()
//    var airplanesAtlas: SKTextureAtlas = SKTextureAtlas(named: "Airplanes")
    var assetsAtlas: SKTextureAtlas = SKTextureAtlas(named: "Assets")
    var imagesAtlas: SKTextureAtlas = SKTextureAtlas(named: "Images")
    
    // Enemy planes
//    var skyEnemy = SKSpriteNode()
    
    // Sky nodes
    var badCloud = SKSpriteNode()
    var powerUp = SKSpriteNode()
    var skyCoins = SKSpriteNode()
    
    // Player's weapons
    var bullets = SKSpriteNode()
    var bomber = SKSpriteNode(imageNamed: "bomber")
    var wingman = SKSpriteNode(imageNamed: "wingman")
    
    // Enemy planes / Ground / weapons
    var enemy1 = SKSpriteNode(imageNamed: "enemy1")
    var enemy2 = SKSpriteNode(imageNamed: "enemy2")
    var enemy3 = SKSpriteNode(imageNamed: "enemy3")
    var enemy4 = SKSpriteNode(imageNamed: "enemy4")
    var enemyArray: [SKSpriteNode] = []
    var randomEnemy = SKSpriteNode()
    var enemyFire = SKSpriteNode()
    
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
    
    
    /********************************** didMoveToView Function **********************************/
    // MARK: - didMoveToView
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Sets the physics delegate and physics body
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        physicsWorld.contactDelegate = self // Physics delegate set
        
        // Backgroung color set with RGB
        backgroundColor = SKColor.init(red: 127/255, green: 189/255, blue: 248/255, alpha: 1.0)
        
        // Adds background sound to game
        let bgMusic = SKAction.playSoundFileNamed("bgMusic", waitForCompletion: true)
        playSound(bgMusic)
        
        
        /********************************* Adding Scroll Background *********************************/
        // MARK: - Scroll Background
        
        // Adding scrolling Main Background
        background.createBackground()
        
        // Adding scrolling midground
        background.createMidground()
        
        // Adding scrolling foreground
        background.createForeground()
    }
    
    
    /********************************* touchesBegan Function **************************************/
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
                player.position.y = location.y // Allows a tap to touch on the y axis
                player.position.x = location.x // Allows a tap to touch on the x axis
                
                
                // Call function when play sound
                let startGameSound = SKAction.playSoundFileNamed("startGame", waitForCompletion: false)
                playSound(startGameSound)
                
                
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
                
                
                /*************************************** Spawning Nodes *************************************/
                // MARK: - Spawning
                
                // Adding our player's plane to the scene
//                createPlane()
                setupPlayer()
                
                
                /********************************* Spawn Timers *********************************/
                // MARK: - Spawn Timers
                
                // Spawning bullets timer call
                timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(GameScene.spawnBullets), userInfo: nil, repeats: false)
                
                // Spawning wingmen timer call
                wingTimer = NSTimer.scheduledTimerWithTimeInterval(8.0, target: self, selector: #selector(GameScene.spawnWingman), userInfo: nil, repeats: true)
                
                // Spawning wingmen timer call
                wingTimer = NSTimer.scheduledTimerWithTimeInterval(12.0, target: self, selector: #selector(GameScene.spawnBomber), userInfo: nil, repeats: true)
                
                // Spawning enemies timer call
                enemyTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(GameScene.spawnEnemyPlane), userInfo: nil, repeats: true)
                
                // Spawning enemy fire timer call
                enemyShoots = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameScene.spawnEnemyFire), userInfo: nil, repeats: true)
                
                // Set enemy tank spawn intervals
                coinsTimer = NSTimer.scheduledTimerWithTimeInterval(20.0, target: self, selector: #selector(GameScene.spawnCoins), userInfo: nil, repeats: true)
                
                // Spawning enemy fire timer call
                powerUpTimer = NSTimer.scheduledTimerWithTimeInterval(30.0, target: self, selector: #selector(GameScene.spawnPowerUps), userInfo: nil, repeats: true)
                
                // Cloud sound timer will for 12 sec and stop, then run again
                cloudTimer = NSTimer.scheduledTimerWithTimeInterval(24.0, target: self, selector: #selector(GameScene.rainBadCloud), userInfo: nil, repeats: true)
                
                
//                /********************************* Preloading Sound & Music *********************************/
//                // MARK: - Spawning
//                
//                // After import AVFoundation, needs do,catch statement to preload sound so no delay
//                func setUpEngine() {
//                    do {
//                        let sounds = ["coin", "startGame", "bgMusic", "biplaneFlying", "gunfire", "mortar", "crash", "powerUp", "skyBoom", "planesFight", "planeMachineGun", "bGCannons", "tank", "prop", "airplaneFlyBy", "airplanep51", "mp5Gun"]
//                        
//                        for sound in sounds {
//                            let player = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(sound, ofType: "mp3")!))
//                            
//                            player.prepareToPlay()
//                            
//                        }
//                    } catch {
//                        print("AVAudio has had an \(error).")
//                    }
//                }
//                
                biplaneFlyingSound = SKAudioNode(fileNamed: "biplaneFlying")
                biplaneFlyingSound.runAction(SKAction.play())
                biplaneFlyingSound.autoplayLooped = true
                
                biplaneFlyingSound.removeFromParent()
                self.addChild(biplaneFlyingSound)
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
            
        }
    }
    
    
    /********************************* touchesEnded Function **************************************/
    // MARK: - touchesEnded
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Each node will collide with the equalled item due to bit mask
        
        // Spawning bullets for our player
        bullets.hidden = false
        spawnBullets()
        
        // Add sound to firing
        gunfireSound = SKAudioNode(fileNamed: "gunfire")
        gunfireSound.runAction(SKAction.play())
        gunfireSound.autoplayLooped = false
        
        self.addChild(gunfireSound)
        bgMusic.runAction(SKAction.pause())
    }
    
    
    /*********************************** Update Function *****************************************/
    // MARK: - Update Function
    
    // HUD for health meter
    override func update(currentTime: NSTimeInterval) {
        
        if !self.gamePaused { // Starts game in pause!!!!!!!
            holdGame()
            self.scene!.view?.paused = false
        }
        
        bgMusic.runAction(SKAction.play())
        
        // Move backgrounds
        moveBackground()
        moveMidground()
        moveForeground()
        
        // Healthbar GUI
        playerHealthBar.position = CGPoint(x: player.position.x, y: player.position.y - player.size.height / 2 - 5)
        updateHealthBar(playerHealthBar, withHealthPoints: playerHP)
        
        // Adding to gameplay health attributes
        healthLabel.text = "Health: \(health)"
        
        // Changes health label red if too low
        if(health <= 3) {
            healthLabel.fontColor = SKColor.redColor()
        }
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
        
        if((contactBody1.categoryBitMask == 4) && (contactBody2.categoryBitMask == 8)) {
//            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
//            smoke = SKEmitterNode(fileNamed: "Smoke")!
//            
//            self.addChild(explosion)
//            self.addChild(smoke)
//            
//            explosion.position = contactBody2.node!.position
//            smoke.position = contactBody2.node!.position
//            
            contactBody2.node!.removeFromParent()
            
//            crashSound = SKAudioNode(fileNamed: "crash")
//            crashSound.runAction(SKAction.play())
//            crashSound.autoplayLooped = false
//            
//            crashSound.removeFromParent()
//            self.addChild(crashSound)
            
            health -= 10
            score += 5
            playerHP = max(0, health - 10)
        }

        // MyBullet VS
        else if((contactBody1.categoryBitMask == 2) && (contactBody2.categoryBitMask == 8)) {
//            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
//            smoke = SKEmitterNode(fileNamed: "Smoke")!
//            
//            explosion.position = (contactBody2.node?.position)!
//            smoke.position = (contactBody2.node?.position)!
//            
//            self.addChild(explosion)
//            self.addChild(smoke)
            
            contactBody2.node?.removeFromParent()
            contactBody1.node?.removeFromParent()
            
//            crashSound.runAction(SKAction.play())
//            crashSound.autoplayLooped = false
//            crashSound.removeFromParent()
//            self.addChild(crashSound)
            
            // Hitting an the enemy adds score and health
            score += 10
            health += 2
            playerHP = max(0, health + 2)
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
//        
//        // MyPlane VS
//        else if ((contactBody1.categoryBitMask == 4) && (contactBody2.categoryBitMask == 1)) {
//            explosion = SKEmitterNode(fileNamed: "FireExplosion")!
//            smoke = SKEmitterNode(fileNamed: "Smoke")!
//            
//            explosion.position = (contactBody1.node?.position)!
//            smoke.position = (contactBody1.node?.position)!
//            
//            self.addChild(explosion)
//            self.addChild(smoke)
//            
//            explosion.removeFromParent()
//            smoke.removeFromParent()
//            
//            contactBody1.node?.removeFromParent()
//            
//            crashSound = SKAudioNode(fileNamed: "crash")
//            crashSound.runAction(SKAction.play())
//            crashSound.autoplayLooped = false
//            
//            crashSound.removeFromParent()
//            self.addChild(crashSound)
//        }
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
    

    /********************************* Background Functions *********************************/
    // MARK: - Background Functions
    
    // Add sound to other classes to avoid AV being nil and crashing
    func playSound(soundVariable: SKAction) {
        runAction(soundVariable)
    }
    
//    // Adding scrolling background
//    func createBackground() {
//        let myBackground = SKTexture(imageNamed: "clouds")
//        
//        for i in 0...1 {
//            let background = SKSpriteNode(texture: myBackground)
//            background.name = "Background"
//            background.zPosition = -30
//            background.anchorPoint = CGPointZero
//            background.position = CGPoint(x: (myBackground.size().width * CGFloat(i)) - CGFloat(1 * i), y: 0)
//            addChild(background)
//        }
//    }
//    
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

//    // Adding scrolling midground
//    func createMidground() {
//        let midground1 = SKTexture(imageNamed: "mountains")
//        
//        for i in 0...2 {
//            let ground = SKSpriteNode(texture: midground1)
//            ground.name = "Midground"
//            ground.zPosition = -20
//            ground.position = CGPoint(x: (midground1.size().width / 2.0 + (midground1.size().width * CGFloat(i))), y: midground1.size().height / 2)
//            
//            // Create physics body
//            ground.physicsBody?.affectedByGravity = false
//            
//            self.addChild(ground)
//        }
//    }
//    
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
    
//    // Adding scrolling foreground
//    func createForeground() {
//        let foreground = SKTexture(imageNamed: "lonelytree")
//        
//        for i in 0...6 {
//            let ground = SKSpriteNode(texture: foreground)
//            ground.name = "Foreground"
//            ground.zPosition = 0
//            ground.position = CGPoint(x: (foreground.size().width / 2.0 + (foreground.size().width * CGFloat(i))), y: foreground.size().height / 2)
//            
//            self.addChild(ground)
//            
//            // Create physics body
//            ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
//            ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground1
//            ground.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4
//            ground.physicsBody?.collisionBitMask = PhysicsCategory.MyPlane4
//            ground.physicsBody?.affectedByGravity = false
//            ground.physicsBody?.dynamic = false
//        }
//    }
//    
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
    
    
    /*********************************** Animation Functions *********************************/
    // MARK: - Plane animation functions
    
    /* func createPlane() {
        
        for i in 1...imagesAtlas.textureNames.count { // Iterates loop for plane animation
            let plane = "myPlane\(i)"
            planeArray.append(SKTexture(imageNamed: plane))
        }
        
        // Add user's animated bi-plane
        myPlane = SKSpriteNode(imageNamed: imagesAtlas.textureNames[0])
        myPlane.setScale(0.2)
        myPlane.zPosition = 6
        myPlane.position = CGPoint(x: self.size.width / 6, y: self.size.height / 2)
        self.addChild(myPlane)
        
        // Body physics of player's plane
        myPlane.physicsBody = SKPhysicsBody(rectangleOfSize: myPlane.size)
        myPlane.physicsBody?.categoryBitMask = PhysicsCategory.MyPlane4
        // Will only collide and bounce with no extra code or reactions
        myPlane.physicsBody?.collisionBitMask = PhysicsCategory.Cloud32 | PhysicsCategory.Enemy8
        // Will make contact and have the abilty to carry out more code
        myPlane.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy8 | PhysicsCategory.Ground1 | PhysicsCategory.EnemyFire16 | PhysicsCategory.PowerUp64 | PhysicsCategory.Coins128 | PhysicsCategory.Rain256
        myPlane.physicsBody?.dynamic = false
        myPlane.physicsBody?.affectedByGravity = false
        
        myPlane.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(planeArray, timePerFrame: 0.05)))
    } */
    
    // From the Player class
    func setupPlayer() {
        player.position = CGPoint(x: CGRectGetMidX(self.frame), y: player.size.height/2 + 10)
        addChild(player)
    }
    
    
    /*********************************** Spawning Functions *********************************/
    // MARK: - Spawning Functions
    
    // Spawn bullets for player's plane
    func spawnBullets() {
        
        // Setup bullet node
        bullets = SKSpriteNode(imageNamed: "Bullet")
        bullets.setScale(0.2)
        bullets.zPosition = 5
        
        bullets.position = CGPoint(x: player.position.x + 50, y: player.position.y)
        
        // Body physics of player's bullets
        bullets.physicsBody = SKPhysicsBody(rectangleOfSize: bullets.size)
        bullets.physicsBody?.categoryBitMask = PhysicsCategory.MyBullets2
        bullets.physicsBody?.contactTestBitMask = PhysicsCategory.All
        bullets.physicsBody?.collisionBitMask = PhysicsCategory.Enemy8 | PhysicsCategory.PowerUp64 | PhysicsCategory.Cloud32 | PhysicsCategory.Coins128
        bullets.physicsBody?.usesPreciseCollisionDetection = true
        bullets.physicsBody?.dynamic = false
        bullets.physicsBody?.affectedByGravity = false
        
        // Shoot em up!
        let action = SKAction.moveToX(self.size.width + 150, duration: 1.0)
        let actionDone = SKAction.removeFromParent()
        bullets.runAction(SKAction.sequence([action, actionDone]))
        
        self.addChild(bullets)
    }
    
    // Adding ally forces in background
    func spawnWingman() {
        
        // Alternate wingmen 1 of 2 passby's in the distance
        wingman = SKSpriteNode(imageNamed: "Fokker")
        wingman.zPosition = -19
        wingman.setScale(0.2)
        
        // Calculate random spawn points for wingmen
        let random = CGFloat(arc4random_uniform(1000) + 400)
        wingman.position = CGPoint(x: -self.size.width, y: random)
        
        // Body physics for player's wingmen
        wingman.physicsBody = SKPhysicsBody(rectangleOfSize: wingman.size)
        wingman.physicsBody?.affectedByGravity = false
        wingman.physicsBody?.dynamic = false
        
        // Move wingmen forward
        let action = SKAction.moveToX(self.size.width + 50, duration: 18.0)
        let actionDone = SKAction.removeFromParent()
        wingman.runAction(SKAction.sequence([action, actionDone]))
        
        wingman.removeFromParent()
        self.addChild(wingman) // Generate the random wingman
    }
    
    // Adding ally forces in background
    func spawnBomber() {
        
        // Alternate wingmen 2 of 2 passby's in the distance
        bomber = SKSpriteNode(imageNamed: "bomber")
        bomber.zPosition = -19
        bomber.setScale(0.3)
        
        // Calculate random spawn points for bomber
        let random = CGFloat(arc4random_uniform(1000) + 400)
        bomber.position = CGPoint(x: -self.size.width, y: random)
        
        // Body physics for player's bomber
        bomber.physicsBody = SKPhysicsBody(rectangleOfSize: bomber.size)
        bomber.physicsBody?.affectedByGravity = false
        bomber.physicsBody?.dynamic = false
        
        // Move bomber forward
        let action = SKAction.moveToX(self.size.width + 80, duration: 22.0)
        let actionDone = SKAction.removeFromParent()
        bomber.runAction(SKAction.sequence([action, actionDone]))
        
        bomber.removeFromParent()
        self.addChild(bomber) // Generate the random wingman
    }
    
/*    // Generate enemy fighter planes
    func spawnEnemyPlane() {
        
        // Sky enemy array
        enemyArray = [enemy1, enemy2, enemy3, enemy4]
        
        // Generate a random index
        let randomIndex = Int(arc4random_uniform(UInt32(enemyArray.count)))
        
        // Get a random enemy
        randomEnemy = enemyArray[randomIndex]

        randomEnemy.setScale(0.25)
        randomEnemy.zPosition = -5
        
        // Calculate random spawn points for air enemies
        randomEnemy.position = CGPoint(x: self.size.width, y: CGFloat(arc4random_uniform(800) + 250))

        // Add enemies
        enemy1.removeFromParent()
        enemy2.removeFromParent()
        enemy3.removeFromParent()
        enemy4.removeFromParent()
        randomEnemy.removeFromParent()
        self.addChild(randomEnemy) // Generate the random enemy
        
        // Body physics for enemy's planes
        randomEnemy.physicsBody = SKPhysicsBody(rectangleOfSize: randomEnemy.size)
        randomEnemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy8
        randomEnemy.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4 | PhysicsCategory.Enemy8 | PhysicsCategory.EnemyFire16
        randomEnemy.physicsBody?.collisionBitMask = PhysicsCategory.MyBullets2 | PhysicsCategory.MyPlane4 | PhysicsCategory.Enemy8 | PhysicsCategory.EnemyFire16
        randomEnemy.physicsBody?.dynamic = false
        randomEnemy.physicsBody?.affectedByGravity = false

        // Move enemies forward
        let action = SKAction.moveToX(-200, duration: 4.0)
        let actionDone = SKAction.removeFromParent()
        randomEnemy.runAction(SKAction.sequence([action, actionDone]))
        
        // Add sound
        airplaneFlyBySound = SKAudioNode(fileNamed: "airplaneFlyBy")
        airplaneFlyBySound.runAction(SKAction.play())
        airplaneFlyBySound.autoplayLooped = false
        airplaneFlyBySound.removeFromParent()
        self.addChild(airplaneFlyBySound)// Alternative sounds to choose from

        spawnEnemyFire()
    } */
    
    // From the Player class
    func setupSkyEnemy() {
        randomEnemy.position = CGPoint(x: self.size.width, y: CGFloat(arc4random_uniform(800) + 250))
    }

    func spawnEnemyFire() {
        enemyFire = SKSpriteNode(imageNamed: "Bullet")
        enemyFire.setScale(0.2)
        enemyFire.zPosition = -5
        enemyFire.xScale = node.xScale * -1

        enemyFire.position = CGPointMake(randomEnemy.position.x - 75, randomEnemy.position.y)
        
        self.addChild(enemyFire) // Generate enemy fire

        // Body physics of player's bullets
        enemyFire.physicsBody = SKPhysicsBody(rectangleOfSize: enemyFire.size)
        enemyFire.name = "EnemyFire"
        enemyFire.physicsBody?.categoryBitMask = PhysicsCategory.EnemyFire16
        enemyFire.physicsBody?.contactTestBitMask = PhysicsCategory.MyBullets2
        enemyFire.physicsBody?.collisionBitMask = PhysicsCategory.MyPlane4 | PhysicsCategory.Enemy8
        enemyFire.physicsBody?.dynamic = false
        enemyFire.physicsBody?.affectedByGravity = false
        
        // Change attributes
        enemyFire.color = UIColor.yellowColor()
        enemyFire.colorBlendFactor = 1.0
        
        // Shoot em up!
        let action = SKAction.moveToX(-30, duration: 1.2)
        let actionDone = SKAction.removeFromParent()
        enemyFire.runAction(SKAction.sequence([action, actionDone]))
        
        // Add gun sound
        mp5GunSound = SKAudioNode(fileNamed: "mp5Gun")
        mp5GunSound.runAction(SKAction.play())
        mp5GunSound.autoplayLooped = false
        
        mp5GunSound.removeFromParent()
        self.addChild(mp5GunSound)
    }
    
    // Spawn sky nodes
    func skyExplosions() {
        
        // Sky explosions of a normal battle
        explosion = SKEmitterNode(fileNamed: "FireExplosion")!
        explosion.particleLifetime = 0.5
        explosion.particleScale = 0.4
        explosion.particleSpeed = 1.5
        explosion.zPosition = 9
        
        let xPos = randomBetweenNumbers(0, secondNum: frame.width )
        
        // Sky bomb position on screen
        explosion.position = CGPoint(x: xPos, y: self.frame.size.height * 0.25)
        
        self.addChild(explosion)
        
        // Physics for sky bomb
        explosion.physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        explosion.name = "SkyBomb"
        explosion.physicsBody?.categoryBitMask = PhysicsCategory.SkyBombs512
        explosion.physicsBody?.contactTestBitMask = PhysicsCategory.MyBullets2 | PhysicsCategory.EnemyFire16
        explosion.physicsBody?.collisionBitMask = PhysicsCategory.MyPlane4 | PhysicsCategory.Enemy8
        explosion.physicsBody?.dynamic = false
        explosion.physicsBody?.affectedByGravity = false
        
        skyBoomSound = SKAudioNode(fileNamed: "skyBoom")
        skyBoomSound.runAction(SKAction.play())
        skyBoomSound.autoplayLooped = false
        
        skyBoomSound.removeFromParent()
        self.addChild(skyBoomSound)
    }
    
    // Spawning coins
    func spawnCoins() {
        
        // Loop to run through .png's for animation
        for i in 1...assetsAtlas.textureNames.count {
            let coins = "Coin_\(i)"
            animationFrames.append(SKTexture(imageNamed: coins))
        }
        
        // Add user's animated coins
        skyCoins = SKSpriteNode(imageNamed: assetsAtlas.textureNames[0])
        
        let xPos = randomBetweenNumbers(0, secondNum: frame.width )
        
        // Star position off screen
        skyCoins.position = CGPoint(x: xPos, y: self.frame.size.height * 0.25)
        skyCoins.setScale(1.0)
        skyCoins.zPosition = 110
        
        self.addChild(skyCoins)
        
        // Added skyCoins physics
        skyCoins.physicsBody = SKPhysicsBody(edgeLoopFromRect: powerUp.frame)
        skyCoins.physicsBody?.categoryBitMask = PhysicsCategory.Coins128
        skyCoins.physicsBody?.contactTestBitMask = PhysicsCategory.None
        skyCoins.physicsBody?.collisionBitMask = PhysicsCategory.MyBullets2 | PhysicsCategory.MyPlane4
        skyCoins.physicsBody?.dynamic = false
        skyCoins.physicsBody?.affectedByGravity = false
        
        // Add sound
        coinSound = SKAudioNode(fileNamed: "coin")
        coinSound.runAction(SKAction.play())
        coinSound.autoplayLooped = false
        coinSound.removeFromParent()
        self.addChild(coinSound)
    }
    
    // Spawning a bonus star
    func spawnPowerUps() {
        
        // Loop to run through .png's for animation
        for i in 1...assetsAtlas.textureNames.count {
            let powerUp = "life_power_up_\(i)"
            animationFrames.append(SKTexture(imageNamed: powerUp))
        }
        
        // Add user's animated powerUp
        powerUp = SKSpriteNode(imageNamed: assetsAtlas.textureNames[0])
        
        let xPos = randomBetweenNumbers(0, secondNum: frame.width )
        
        // Star position off screen
        powerUp.position = CGPoint(x: xPos, y: self.frame.size.height * 0.25)
        powerUp.setScale(0.9)
        powerUp.zPosition = 11
        
        powerUp.removeFromParent()
        self.addChild(powerUp)
        
        // Added star's physics
        powerUp.physicsBody = SKPhysicsBody(edgeLoopFromRect: powerUp.frame)
        powerUp.physicsBody?.categoryBitMask = PhysicsCategory.PowerUp64
        powerUp.physicsBody?.contactTestBitMask = PhysicsCategory.None
        powerUp.physicsBody?.collisionBitMask = PhysicsCategory.MyBullets2 | PhysicsCategory.MyPlane4
        powerUp.physicsBody?.dynamic = false
        powerUp.physicsBody?.affectedByGravity = false
        
        // Add sound
        powerUpSound = SKAudioNode(fileNamed: "powerUp")
        powerUpSound.runAction(SKAction.play())
        powerUpSound.autoplayLooped = false
        powerUpSound.removeFromParent()
        self.addChild(powerUpSound)
    }
    
    // Introducing the cloud using linear interpolation
    func cloudOnAPath() {
        
        badCloud = SKSpriteNode(imageNamed: "badCloud")
        badCloud.zPosition = -21
        
        // Randomly place cloud on Y axis
        let actualY = CGFloat.random(min: 400, max: self.frame.size.height - 100)
        
        // Clouds position off screen
        badCloud.position = CGPoint(x: size.width + badCloud.size.width / 2, y: actualY)
        
        // This time I will determine speed by velocity rather than time interval
        let actualDuration = CGFloat.random(min: CGFloat(10.0), max: CGFloat(15.0))
        
        self.addChild(badCloud) // Generate "bonus" star
        
        // Added star's physics
        badCloud.physicsBody = SKPhysicsBody(edgeLoopFromRect: badCloud.frame)
        badCloud.physicsBody?.affectedByGravity = false
        badCloud.physicsBody?.categoryBitMask = PhysicsCategory.Cloud32
        badCloud.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4 | PhysicsCategory.Enemy8 | PhysicsCategory.EnemyFire16 | PhysicsCategory.PowerUp64 | PhysicsCategory.Coins128
        badCloud.physicsBody?.collisionBitMask = PhysicsCategory.MyBullets2
        badCloud.physicsBody?.dynamic = false
        
        // Create a path func cloudOnAPath() {
        let actionMove = SKAction.moveTo(CGPoint(x: -badCloud.size.width / 2, y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        badCloud.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        badCloud.shadowCastBitMask = 1
        badCloud.lightingBitMask = 1
        
        // Put bad cloud on a linear interpolation path
        runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock(cloudOnAPath),
            SKAction.waitForDuration(12.0)
            ])
            ))
    }
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    

    /*********************************** Emitter Functions *********************************/
    // MARK: - Emitter Functions
    
    // Adding emitter to follow cloud and rain in time intervals
    func rainBadCloud() {
        
        // Cloud will rain within intervals
        rain = SKEmitterNode(fileNamed: "Rain")
        rain!.zPosition = -29.5
        rain!.setScale(0.8)
        
        // Set physics for rain
        rain!.physicsBody?.affectedByGravity = false
        rain!.physicsBody?.categoryBitMask = PhysicsCategory.Rain256
        rain!.physicsBody?.contactTestBitMask = PhysicsCategory.MyPlane4 | PhysicsCategory.Enemy8 | PhysicsCategory.EnemyFire16 | PhysicsCategory.PowerUp64 | PhysicsCategory.Coins128
        rain!.physicsBody?.collisionBitMask = 2048
        
        // Follows cloud
        rain!.targetNode = self.scene
        badCloud.addChild(rain!)
    }
    
    // Healthbar function for visual display
    func updateHealthBar(node: SKSpriteNode, withHealthPoints hp: Int) {
        
        let barSize = CGSize(width: healthBarWidth, height: healthBarHeight);
        
        let fillColor = UIColor(red: 113.0/255, green: 202.0/255, blue: 53.0/255, alpha:1)
        let borderColor = UIColor(red: 35.0/255, green: 28.0/255, blue: 40.0/255, alpha:1)
        
        // create drawing context
        UIGraphicsBeginImageContextWithOptions(barSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // draw the outline for the health bar
        borderColor.setStroke()
        let borderRect = CGRect(origin: CGPointZero, size: barSize)
        CGContextStrokeRectWithWidth(context, borderRect, 1)
        
        // draw the health bar with a colored rectangle
        fillColor.setFill()
        let barWidth = (barSize.width - 1) * CGFloat(hp) / CGFloat(maxHealth)
        let barRect = CGRect(x: 0.5, y: 0.5, width: barWidth, height: barSize.height - 1)
        CGContextFillRect(context, barRect)
        
        // extract image
        let spriteImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // set sprite texture and size
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
        powerUp = SKSpriteNode(imageNamed: "life_power_up_1")
        powerUp.zPosition = 100
        powerUp.size = CGSize(width: 75, height: 75)
        powerUp.position = CGPoint(x: 75, y: display.size.height / 2 - 75)
        powerUp.name = "PowerUp"
        
        // Label to let user know the count of power ups
        powerUpLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
        powerUpLabel.zPosition = 100
        powerUpCount = 0
        powerUpLabel.color = UIColor.redColor()
        powerUpLabel.colorBlendFactor = 1.0
        powerUpLabel.text = " X \(powerUpCount)"
        powerUpLabel.fontSize = powerUp.size.height
        powerUpLabel.position = CGPoint(x: powerUp.frame.width + 125, y: display.size.height / 2 - 105)
        
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
        coinCountLbl.fontSize = powerUp.size.height
        coinCountLbl.position = CGPoint(x: self.frame.width - 75, y: display.size.height / 2 - 115)
        
        self.addChild(display)
        pauseNode.removeFromParent()
        display.addChild(pauseNode)
        display.addChild(pauseButton)
        display.addChild(healthLabel)
        display.addChild(powerUp)
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
            self.player.position = CGPointMake(self.size.width/2, self.size.height/2)
            self.player.runAction(SKAction.fadeInWithDuration(1), completion: {
                self.scene!.view?.paused = true
            })
        })
    }
    
    /********************************** Simulating Physics ***************************************/
    // MARK: - Simulate Physics
    
    override func didSimulatePhysics() {
        
    }
}
