//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Noy Hillel on 24/02/2017.
//  Copyright © 2017 Inscriptio. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var background = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        let backgroundTexture = SKTexture(imageNamed: "bg.png")
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -backgroundTexture.size().width, dy: 0), duration: 7)
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
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.run(makeBirdFlap)
        self.addChild(bird)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
