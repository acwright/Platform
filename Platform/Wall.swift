//
//  Wall.swift
//  Platform
//
//  Created by Aaron Wright on 3/30/15.
//  Copyright (c) 2015 Aaron Wright. All rights reserved.
//

import SpriteKit

class Wall: SKNode {
    
    struct Collision {
        enum Direction {
            case None, Top, Bottom, Left, Right
        }
        
        let direction: Direction
        let rect: CGRect
        
        var hasCollision: Bool {
            get { return direction != Direction.None }
        }
    }
    
    override init() {
        super.init()
        
        let floor = SKSpriteNode(color: SKColor.red, size: CGSize(width: 512, height: 32))
        floor.anchorPoint = CGPoint.zero
        floor.position = CGPoint(x: 0, y: 0)

        let platform = SKSpriteNode(color: SKColor.red, size: CGSize(width: 64, height: 32))
        platform.anchorPoint = CGPoint.zero
        platform.position = CGPoint(x: 128, y: 96)

        let wall1 = SKSpriteNode(color: SKColor.red, size: CGSize(width: 32, height: 256))
        wall1.anchorPoint = CGPoint.zero
        wall1.position = CGPoint(x: 0, y: 32)

        let wall2 = SKSpriteNode(color: SKColor.red, size: CGSize(width: 32, height: 128))
        wall2.anchorPoint = CGPoint.zero
        wall2.position = CGPoint(x: 512 - 32, y: 32)
        
        self.addChild(floor)
        self.addChild(platform)
        self.addChild(wall1)
        self.addChild(wall2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func resolveCollisions(player: Player) {
        player.grounded = false
        
        let playerRect = player.collisionBoundingBox()
        
        for child in self.children as! [SKSpriteNode] {
            let childRect = child.frame
            
            let collision = self.testRectangleCollision(A: childRect, B: playerRect)
            
            if collision.hasCollision {
                switch collision.direction {
                case .Top:
                    player.desiredPosition = CGPoint(x: player.desiredPosition.x, y: player.desiredPosition.y + collision.rect.size.height)
                    player.velocity = CGVector(dx: player.velocity.dx, dy: 0.0)
                    player.grounded = true
                case .Bottom:
                    player.desiredPosition = CGPoint(x: player.desiredPosition.x, y: player.desiredPosition.y - collision.rect.size.height)
                    player.velocity = CGVector(dx: player.velocity.dx, dy: 0.0)
                case .Left:
                    player.desiredPosition = CGPoint(x: player.desiredPosition.x + collision.rect.size.width, y: player.desiredPosition.y)
                    player.velocity = CGVector(dx: 0.0, dy: player.velocity.dy)
                case .Right:
                    player.desiredPosition = CGPoint(x: player.desiredPosition.x - collision.rect.size.width, y: player.desiredPosition.y)
                    player.velocity = CGVector(dx: 0.0, dy: player.velocity.dy)
                default:
                    break
                }
            }
            player.position = player.desiredPosition
        }
    }
    
    func testRectangleCollision(A: CGRect, B: CGRect) -> Collision {
        var rect = CGRect.null
        var direction = Collision.Direction.None
        
        if !A.equalTo(B) && (!A.isNull && !B.isNull) {
            
            rect = A.intersection(B)
            
            if !rect.isNull {
                if rect.height >= rect.width
                {
                    direction = (A.origin.x <= B.origin.x) ? .Left : .Right
                }
                else
                {
                    direction = (A.origin.y >= B.origin.y) ? .Bottom : .Top
                }
            }
        }
        
        return Collision(direction: direction, rect: rect)
    }
    
}
