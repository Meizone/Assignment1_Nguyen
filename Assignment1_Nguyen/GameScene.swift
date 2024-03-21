//
//  GameScene.swift
//  Assignment1_Nguyen
//
//  Created by Tech on 2021-02-26.
//  Copyright © 2021 Tech. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    private var Ball:SKShapeNode!
    private var Brick:SKShapeNode!
    private var Paddle:SKShapeNode!
    
    private var Wall1:SKShapeNode!
    private var Wall2:SKShapeNode!
    private var Wall3:SKShapeNode!
    private var Wall4:SKShapeNode!
    private var brickTracker:Int = 0
    private var PaddleTouch = false
    private var previousTouch:CGPoint!
    
    private var gameOverScene:SKScene!
    private var gameWinScene:SKScene!
    
    let EDGE:UInt32 = 0x1 << 0
    let LOSEEDGE:UInt32 = 0x1 << 1
    let BRICK:UInt32 = 0x1 << 2
    let PADDLE:UInt32 = 0x1 << 3
    let BALL:UInt32 = 0x1 << 4
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy:0)
        self.physicsWorld.contactDelegate = self
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.categoryBitMask = EDGE
        borderBody.friction = 0
        self.physicsBody = borderBody
        
       
        
        
        //Bottom Floor
        Wall1 = SKShapeNode(rectOf: CGSize(width: 620, height: 20))
        Wall1.fillColor = SKColor.yellow
        Wall1.position = CGPoint(x:0, y: -600)
        Wall1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 820, height:20))
        Wall1.physicsBody?.categoryBitMask = LOSEEDGE
        Wall1.physicsBody?.contactTestBitMask = BALL
        Wall1.physicsBody?.collisionBitMask = BALL
        Wall1.physicsBody?.isDynamic = false
        Wall1.physicsBody?.friction = 0
        self.addChild(Wall1)
        
        //Top Floor
        Wall2 = SKShapeNode(rectOf: CGSize(width: 620, height: 20))
        Wall2.fillColor = SKColor.yellow
        Wall2.position = CGPoint(x:0, y: 600)
        Wall2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 820, height:20))
        Wall2.physicsBody?.categoryBitMask = EDGE
        Wall2.physicsBody?.collisionBitMask = BALL
        Wall2.physicsBody?.isDynamic = false
        Wall2.physicsBody?.friction = 0
        self.addChild(Wall2)
        
        //Left Floor
        Wall3 = SKShapeNode(rectOf: CGSize(width: 20, height: 1200))
        Wall3.fillColor = SKColor.yellow
        Wall3.position = CGPoint(x:-300, y: 0)
        Wall3.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height:1200))
        Wall3.physicsBody?.categoryBitMask = EDGE
        Wall3.physicsBody?.collisionBitMask = BALL
        Wall3.physicsBody?.isDynamic = false
        Wall3.physicsBody?.friction = 0
        self.addChild(Wall3)
        
        //Right Floor
        Wall4 = SKShapeNode(rectOf: CGSize(width: 20, height: 1200))
        Wall4.fillColor = SKColor.yellow
        Wall4.position = CGPoint(x:300, y: 0)
        Wall4.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height:1200))
        Wall4.physicsBody?.categoryBitMask = EDGE
        Wall4.physicsBody?.collisionBitMask = BALL
        Wall4.physicsBody?.isDynamic = false
        Wall4.physicsBody?.friction = 0
        self.addChild(Wall4)
        
        Paddle = SKShapeNode(rectOf: CGSize(width:100, height: 15))
        Paddle.fillColor = SKColor.red
        Paddle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:100, height: 15))
        Paddle.physicsBody?.isDynamic = false
        Paddle.position = CGPoint(x:0, y:-550)
        self.addChild(Paddle)
        
        
        Ball = SKShapeNode(circleOfRadius: 35)
        Ball.physicsBody?.categoryBitMask = BALL
        Ball.physicsBody?.collisionBitMask = EDGE | LOSEEDGE | BRICK
        Ball.physicsBody?.contactTestBitMask = EDGE | LOSEEDGE | BRICK
        Ball.fillColor = SKColor.red
        Ball.position = CGPoint(x:0, y:-130)
        Ball.physicsBody = SKPhysicsBody(circleOfRadius: 35)
        Ball.physicsBody?.friction = 0
        Ball.physicsBody?.restitution = 1
        Ball.physicsBody?.linearDamping = 0
        Ball.physicsBody?.allowsRotation = false
        self.addChild(Ball)
        
        Ball.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50))
        
        
        let numbRows = 2 //2
        let brickCount = 5 //5

        
        for i in 1 ... numbRows {
            for j in 1 ... brickCount {
                Brick = SKShapeNode(rectOf: CGSize(width:75, height: 15))
                Brick.fillColor = SKColor.blue
                Brick.position = CGPoint(x: -290 + (j*100), y: 600 - (i*100) )
                Brick.physicsBody = SKPhysicsBody(rectangleOf:CGSize(width: 75, height: 15))
                Brick.physicsBody?.allowsRotation = false
                Brick.physicsBody?.friction = 0
                Brick.physicsBody?.categoryBitMask = BRICK
                Brick.physicsBody?.contactTestBitMask = BALL
                Brick.physicsBody?.isDynamic = false
                brickTracker += 1
                self.addChild(Brick)
            }
        }

    }
    
    override func sceneDidLoad() {
        gameWinScene = SKScene(fileNamed: "GameWin")
        gameOverScene = SKScene(fileNamed: "GameOver")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       if let t = touches.first {
            let pos = t.location(in: self)
            let touchedNodes = self.nodes(at: pos)
            if( touchedNodes.count > 0) {
                for n in touchedNodes {
                    if n == Paddle {
                        PaddleTouch = true
                        previousTouch = pos
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if PaddleTouch {
            Paddle.position.x = (touches.first?.location(in:self).x)!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        PaddleTouch = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node == Ball && contact.bodyB.categoryBitMask == LOSEEDGE) ||
        (contact.bodyA.categoryBitMask == LOSEEDGE && contact.bodyB.node == Ball)
        {
           self.view?.presentScene(gameOverScene,transition: .reveal(with:.right, duration: 1))
            print("LOST")
        }
        else if (contact.bodyA.node == Ball && contact.bodyB.categoryBitMask == BRICK) ||
            (contact.bodyA.categoryBitMask == BRICK && contact.bodyB.node == Ball)
        {
            print("BRICK HIT")
            if(contact.bodyA.categoryBitMask == BRICK) {
                contact.bodyA.node?.removeFromParent()
                brickTracker -= 1
                
            }
            else if (contact.bodyB.categoryBitMask == BRICK) {
                contact.bodyB.node?.removeFromParent()
                brickTracker -= 1
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(brickTracker <= 0) {
            self.view?.presentScene(gameWinScene,transition: .reveal(with:.right, duration: 1))
        }
    
    
}
    
}
