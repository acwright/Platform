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
    
    var _size = CGSize(width: 32, height: 32)
    
    var velocity = CGVector.zero
    var desiredPosition = CGPoint.zero
    var grounded: Bool = false
    var direction: Direction = Direction.None
    var jumping: Jumping = Jumping.Off
    var jumpReset: Bool = true
    
    let gravity: CGFloat = -42.0
    let jumpCutoff: CGFloat = 11.0
    let accelerationGroundDamping: CGFloat = 0.95
    let accelerationGround = CGVector(dx: 18, dy: 22)
    let accelerationAir = CGVector(dx: 12, dy: 0)
    let accelerationAirReverseAllowance: CGFloat = 2.0
    let accelerationMaxClamping = CGVector(dx: 36, dy: 34)
    let accelerationMinClamping = CGVector(dx: -36, dy: -56)
    
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
            self.jumping = Jumping.On
        }
    }
    
    func update(dt: TimeInterval) {
        self.velocity = CGVector(dx: 0.0, dy: self.gravity * CGFloat(dt))
        
        if self.grounded {
            if self.direction == Direction.Left {
                self.velocity += CGVector(dx: -self.accelerationGround.dx * CGFloat(dt), dy: 0.0)
            } else if self.direction == Direction.Right {
                self.velocity += CGVector(dx: self.accelerationGround.dx * CGFloat(dt), dy: 0.0)
            } else {
                if self.velocity.dx != 0.0 {
                    self.velocity.dx = self.velocity.dx * self.accelerationGroundDamping * (1 - CGFloat(dt))
                }
            }
        } else {
            if self.direction == Direction.Left && self.velocity.dx >= -self.accelerationAirReverseAllowance {
                self.velocity += CGVector(dx: -self.accelerationAir.dx * CGFloat(dt), dy: 0.0)
            } else if self.direction == Direction.Right && self.velocity.dx <= self.accelerationAirReverseAllowance {
                self.velocity += CGVector(dx: self.accelerationAir.dx * CGFloat(dt), dy: 0.0)
            }
        }
        
        if self.jumping == Jumping.On {
            if self.grounded && self.jumpReset {
                self.velocity += CGVector(dx: 0.0, dy: self.accelerationGround.dy)
                self.grounded = false
                self.jumpReset = false
            }
        } else if self.jumping == Jumping.Off {
            if self.velocity.dy > self.jumpCutoff {
                self.velocity.dy = self.jumpCutoff
            }
            
            if self.grounded && self.jumpReset == false {
                self.jumpReset = true
            }
        }
   
        self.velocity.dx = self.velocity.dx.clamped(v1: self.accelerationMinClamping.dx, v2: self.accelerationMaxClamping.dx)
        self.velocity.dy = self.velocity.dy.clamped(v1: self.accelerationMinClamping.dy, v2: self.accelerationMaxClamping.dy)
 
        self.desiredPosition = self.position + self.velocity
    }
    
    func collisionBoundingBox() -> CGRect {
        let x = self.desiredPosition.x - (self._size.width / 2)
        let y = self.desiredPosition.y - (self._size.height / 2)
        let box = CGRect(x: x, y: y, width: self._size.width, height: self._size.height)
        
        return box
    }
    
}
