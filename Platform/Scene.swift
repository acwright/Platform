//
//  Scene.swift
//  Platform
//
//  Created by Aaron Wright on 3/30/15.
//  Copyright (c) 2015 Aaron Wright. All rights reserved.
//

import SpriteKit

class Scene: SKScene {
    
    var world: SKNode!
    
    var lastUpdateTime: TimeInterval!
    var dt: TimeInterval!

    var player: Player!
    var walls: [Wall] = []
    
    override func didMove(to view: SKView) {
        self.world = SKNode()
        self.addChild(self.world)
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.world.position = CGPoint(x: -256, y: -256)
        
        self.player = Player(color: SKColor.green, size: CGSize(width: 32, height: 32))
        self.player.position = CGPoint(x: 256, y: 256)
        self.player.zPosition = 10
        
        let wall = Wall()
        self.walls.append(wall)
        
        self.world.addChild(wall)
        self.world.addChild(self.player)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let lastUpdateTime = self.lastUpdateTime {
            self.dt = currentTime - lastUpdateTime
        } else {
            self.dt = 0
        }
        self.lastUpdateTime = currentTime
        
        self.player.update(dt: self.dt)
        
        for wall in self.walls {
            wall.resolveCollisions(player: self.player)
        }
        
        if self.player.position.y < 0 {
            self.player.position = CGPoint(x: 256, y: 256)
        }
    }
    
    override func keyDown(with theEvent: NSEvent) {
        if let utf16View = theEvent.charactersIgnoringModifiers?.utf16 {
            switch Int(utf16View[utf16View.startIndex]) {
            case NSLeftArrowFunctionKey:
                self.player.left()
            case NSRightArrowFunctionKey:
                self.player.right()
            case NSUpArrowFunctionKey:
                self.player.jump(cancel: false)
            default:
                break
            }
            
            if theEvent.keyCode == 49 {
                self.player.jump(cancel: false)
            }
        }
    }
    
    override func keyUp(with theEvent: NSEvent) {
        if let utf16View = theEvent.charactersIgnoringModifiers?.utf16 {
            switch Int(utf16View[utf16View.startIndex]) {
            case NSLeftArrowFunctionKey:
                self.player.stop()
            case NSRightArrowFunctionKey:
                self.player.stop()
            case NSUpArrowFunctionKey:
                self.player.jump(cancel: true)
            default:
                break
            }
            
            if theEvent.keyCode == 49 {
                self.player.jump(cancel: true)
            }
        }
    }
}
