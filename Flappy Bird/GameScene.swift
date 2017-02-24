//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Noy Hillel on 24/02/2017.
//  Copyright © 2017 Inscriptio. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum State: UInt32 {
        case BIRD = 1
        case OBJECT = 2 // pipe or the floor or roof
        case SPACE_AREA = 4
    }
    
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    var gameOver = false
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var timer = Timer()
    
    func make() {
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))
        let gapHeight = bird.size.height * 5 // makes game easier or harder
        let movement = arc4random() % UInt32(self.frame.height / 2)
        let pipeMoveUpOrDown = CGFloat(movement) - self.frame.height / 4
        
        let pipeTexture = SKTexture(imageNamed: "pipe2.png")
        let pipe = SKSpriteNode(texture: pipeTexture)
        pipe.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height/2 + gapHeight / 2 + pipeMoveUpOrDown)
        pipe.run(movePipes)
        pipe.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe.physicsBody!.isDynamic = false
        pipe.physicsBody!.contactTestBitMask = State.OBJECT.rawValue
        pipe.physicsBody!.categoryBitMask = State.OBJECT.rawValue
        pipe.physicsBody?.collisionBitMask = State.OBJECT.rawValue
        self.addChild(pipe)
        
        let pipeTexture2 = SKTexture(imageNamed: "pipe1.png")
        let pipe2 = SKSpriteNode(texture: pipeTexture2)
        pipe2.run(movePipes)
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe2.physicsBody!.isDynamic = false
        pipe2.physicsBody!.contactTestBitMask = State.OBJECT.rawValue
        pipe2.physicsBody!.categoryBitMask = State.OBJECT.rawValue
        pipe2.physicsBody?.collisionBitMask = State.OBJECT.rawValue
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipeTexture2.size().height/2 - gapHeight / 2 + pipeMoveUpOrDown)
        self.addChild(pipe2)
        
        let spaceArea = SKNode()
        spaceArea.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeMoveUpOrDown)
        spaceArea.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHeight))
        spaceArea.physicsBody!.isDynamic = false
        spaceArea.run(movePipes)
        spaceArea.physicsBody!.contactTestBitMask = State.BIRD.rawValue
        spaceArea.physicsBody!.categoryBitMask = State.SPACE_AREA.rawValue
        spaceArea.physicsBody!.collisionBitMask = State.SPACE_AREA.rawValue
        self.addChild(spaceArea)
        
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        start()
        
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.make), userInfo: nil, repeats: true)
        
        let backgroundTexture = SKTexture(imageNamed: "bg.png")
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -backgroundTexture.size().width, dy: 0), duration: 2)
        let shiftBackground = SKAction.move(by: CGVector(dx: backgroundTexture.size().width, dy: 0), duration: 0)
        let animateBack = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBackground]))
        
        var i: CGFloat = 0
        
        while i < 4 {
            background = SKSpriteNode(texture: backgroundTexture)
            background.position = CGPoint(x:  backgroundTexture.size().width * i, y: self.frame.midY)
            background.size.height = self.frame.height
            background.run(animateBack)
            background.zPosition = -1
            self.addChild(background)
            i += 1
        }
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        // Set the bird = to the image
        bird = SKSpriteNode(texture: birdTexture)
        // Set the position
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        // Run the animation
        bird.run(makeBirdFlap)
        
        // Set the bird's physics body
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        
        // Set the bird not to move initially
        bird.physicsBody!.isDynamic = false
        
        // Creating the collision types
        bird.physicsBody!.contactTestBitMask = State.OBJECT.rawValue
        bird.physicsBody!.categoryBitMask = State.BIRD.rawValue
        bird.physicsBody?.collisionBitMask = State.OBJECT.rawValue
        // Add the bird to the screen
        self.addChild(bird)
        
        let ground = SKNode()
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody!.isDynamic = false
        ground.physicsBody!.contactTestBitMask = State.OBJECT.rawValue
        ground.physicsBody!.categoryBitMask = State.OBJECT.rawValue
        ground.physicsBody?.collisionBitMask = State.OBJECT.rawValue
        self.addChild(ground)
        
        let roof = SKNode()
        roof.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2)
        roof.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        roof.physicsBody!.isDynamic = false
        roof.physicsBody!.contactTestBitMask = State.OBJECT.rawValue
        roof.physicsBody!.categoryBitMask = State.OBJECT.rawValue
        roof.physicsBody?.collisionBitMask = State.OBJECT.rawValue
        self.addChild(roof)
        
        scoreLabel.fontName = "Menlo-Regular"
        scoreLabel.zPosition = 10
        scoreLabel.fontSize = 120
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 150)
        self.addChild(scoreLabel)
    }
    
    var score = 0
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameOver == false {
            if contact.bodyA.categoryBitMask == State.SPACE_AREA.rawValue || contact.bodyB.categoryBitMask == State.SPACE_AREA.rawValue {
                score += 1
                scoreLabel.text = String(score)
            } else {
                self.speed = 0
                self.gameOver = true
                timer.invalidate()
                gameOverLabel.fontName = "Menlo-Regularr"
                gameOverLabel.fontSize = 40
                gameOverLabel.text = "Game Over! Tap to play again!"
                gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                gameOverLabel.zPosition = 10
                self.addChild(gameOverLabel)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver == false {
            bird.physicsBody!.isDynamic = true
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 50))
        } else {
            gameOver = false
            score = 0
            self.speed = 1
            self.removeAllChildren()
            start()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {}
}
