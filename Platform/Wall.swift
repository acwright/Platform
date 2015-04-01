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
        
        let floor = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(512, 32))
        floor.anchorPoint = CGPointZero
        floor.position = CGPointMake(0, 0)
        
        let platform = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(64, 32))
        platform.anchorPoint = CGPointZero
        platform.position = CGPointMake(128, 96)
        
        let wall1 = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(32, 256))
        wall1.anchorPoint = CGPointZero
        wall1.position = CGPointMake(0, 32)
        
        let wall2 = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(32, 128))
        wall2.anchorPoint = CGPointZero
        wall2.position = CGPointMake(512 - 32, 32)
        
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
        
        for child in self.children as [SKSpriteNode] {
            let childRect = child.frame
            
            let collision = self.testRectangleCollision(A: childRect, B: playerRect)
            
            if collision.hasCollision {
                switch collision.direction {
                case .Top:
                    player.desiredPosition = CGPointMake(player.desiredPosition.x, player.desiredPosition.y + collision.rect.size.height)
                    player.velocity = CGVectorMake(player.velocity.dx, 0.0)
                    player.grounded = true
                case .Bottom:
                    player.desiredPosition = CGPointMake(player.desiredPosition.x, player.desiredPosition.y - collision.rect.size.height)
                    player.velocity = CGVectorMake(player.velocity.dx, 0.0)
                case .Left:
                    player.desiredPosition = CGPointMake(player.desiredPosition.x + collision.rect.size.width, player.desiredPosition.y)
                case .Right:
                    player.desiredPosition = CGPointMake(player.desiredPosition.x - collision.rect.size.width, player.desiredPosition.y)
                default:
                    break
                }
            }
            player.position = player.desiredPosition
        }
    }
    
    func testRectangleCollision(#A: CGRect, B: CGRect) -> Collision {
        var rect = CGRectNull
        var direction = Collision.Direction.None
        
        if !CGRectEqualToRect(A, B) && (!CGRectIsNull(A) && !CGRectIsNull(B)) {
            
            rect = CGRectIntersection(A, B)
            
            if !CGRectIsNull(rect) {
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
