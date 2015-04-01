//
//  Player.swift
//  Platform
//
//  Created by Aaron Wright on 3/30/15.
//  Copyright (c) 2015 Aaron Wright. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    enum Direction {
        case Left
        case Right
        case None
    }
    
    enum Jumping {
        case On
        case Off
    }
    
    var _size = CGSizeMake(32, 32)
    
    var velocity = CGVectorMake(0.0, 0.0)
    var desiredPosition = CGPointZero
    var grounded: Bool = false
    var direction: Direction = Direction.None
    var jumping: Jumping = Jumping.Off
    
    let gravity: CGFloat = -7.8
    let damping: CGFloat = 0.7
    let jumpCutoff: CGFloat = 15.0
    let acceleration = CGVectorMake(3.0, 55.0)
    let accelerationMaxClamping = CGVectorMake(15.0, 55.0)
    let accelerationMinClamping = CGVectorMake(-15.0, -15.0)
    
    var jumpable: Bool = true

    func left() {
        self.direction = Direction.Left
    }
    
    func right() {
        self.direction = Direction.Right
    }
    
    func stop() {
        self.direction = Direction.None
    }
    
    func jump(cancel: Bool) {
        if cancel {
            self.jumping = Jumping.Off
            self.jumpable = true
        } else {
            if self.jumpable {
                self.jumping = Jumping.On
            }
        }
    }
    
    func update(dt: NSTimeInterval) {
        if self.direction == Direction.Left {
            self.velocity += CGVectorMake(-self.acceleration.dx, 0.0)
        } else if self.direction == Direction.Right {
            self.velocity += CGVectorMake(self.acceleration.dx, 0.0)
        } else {
            self.velocity.dx = self.velocity.dx * self.damping
        }
        
        if self.jumping == Jumping.On {
            if self.grounded && self.jumpable {
                if self.velocity.dy < self.accelerationMaxClamping.dy {
                    self.velocity += CGVectorMake(0.0, self.acceleration.dy)
                }
                self.jumpable = false
                self.grounded = false
            } else {
                self.velocity += CGVectorMake(0.0, self.gravity)
            }
        } else {
            self.velocity += CGVectorMake(0.0, self.gravity)
            
            if self.velocity.dy > self.jumpCutoff {
                self.velocity = CGVectorMake(self.velocity.dx, self.jumpCutoff)
            }
            self.grounded = true
        }
        
        self.velocity.dx = self.velocity.dx.clamped(self.accelerationMinClamping.dx, self.accelerationMaxClamping.dx)
        self.velocity.dy = self.velocity.dy.clamped(self.accelerationMinClamping.dy, self.accelerationMaxClamping.dy)
        
        self.velocity += self.velocity * CGFloat(dt)
        
        self.desiredPosition = self.position + self.velocity
    }
    
    func collisionBoundingBox() -> CGRect {
        let x = self.desiredPosition.x - (self._size.width / 2)
        let y = self.desiredPosition.y - (self._size.height / 2)
        let box = CGRectMake(x, y, self._size.width, self._size.height)
        
        return box
    }
    
}
