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
    var jumpReset: Bool = true
    
    let gravity: CGFloat = -42.0
    let jumpCutoff: CGFloat = 11.0
    let accelerationGroundDamping: CGFloat = 0.95
    let accelerationGround = CGVectorMake(18.0, 22.0)
    let accelerationAir = CGVectorMake(12.0, 0.0)
    let accelerationAirReverseAllowance: CGFloat = 2.0
    let accelerationMaxClamping = CGVectorMake(36.0, 34.0)
    let accelerationMinClamping = CGVectorMake(-36.0, -56.0)
    
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
        } else {
            if self.grounded && self.jumpReset {
                self.jumping = Jumping.On
                self.grounded = false
                self.jumpReset = false
                
                self.velocity += CGVectorMake(0.0, self.accelerationGround.dy)
            }
        }
    }
    
    func update(dt: NSTimeInterval) {
        self.velocity += CGVectorMake(0.0, self.gravity * CGFloat(dt))
        
        if self.grounded {
            if self.direction == Direction.Left {
                self.velocity += CGVectorMake(-self.accelerationGround.dx * CGFloat(dt), 0.0)
            } else if self.direction == Direction.Right {
                self.velocity += CGVectorMake(self.accelerationGround.dx * CGFloat(dt), 0.0)
            } else {
                if self.velocity.dx != 0.0 {
                    self.velocity.dx = self.velocity.dx * self.accelerationGroundDamping * (1 - CGFloat(dt))
                }
            }
        } else {
            if self.direction == Direction.Left && self.velocity.dx >= -self.accelerationAirReverseAllowance {
                self.velocity += CGVectorMake(-self.accelerationAir.dx * CGFloat(dt), 0.0)
            } else if self.direction == Direction.Right && self.velocity.dx <= self.accelerationAirReverseAllowance {
                self.velocity += CGVectorMake(self.accelerationAir.dx * CGFloat(dt), 0.0)
            }
        }
        
        if self.jumping == Jumping.On {
            self.jumpReset = false
        } else if self.jumping == Jumping.Off {
            if self.velocity.dy > self.jumpCutoff {
                self.velocity.dy = self.jumpCutoff
            }
            
            if self.grounded {
                self.jumpReset = true
            }
        }
        
        if self.velocity.dy == 0 {
            self.grounded = true
        }
   
        self.velocity.dx = self.velocity.dx.clamped(self.accelerationMinClamping.dx, self.accelerationMaxClamping.dx)
        self.velocity.dy = self.velocity.dy.clamped(self.accelerationMinClamping.dy, self.accelerationMaxClamping.dy)
 
        self.desiredPosition = self.position + self.velocity
    }
    
    func collisionBoundingBox() -> CGRect {
        let x = self.desiredPosition.x - (self._size.width / 2)
        let y = self.desiredPosition.y - (self._size.height / 2)
        let box = CGRectMake(x, y, self._size.width, self._size.height)
        
        return box
    }
    
}
