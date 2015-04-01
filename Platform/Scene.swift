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
    
    var lastUpdateTime: NSTimeInterval!
    var dt: NSTimeInterval!

    var player: Player!
    var walls: [Wall] = []
    
    override func didMoveToView(view: SKView) {
        self.world = SKNode()
        self.addChild(self.world)
        
        self.anchorPoint = CGPointMake(0.5, 0.5)
        self.world.position = CGPointMake(-256, -256)
        
        self.player = Player(color: SKColor.greenColor(), size: CGSizeMake(32, 32))
        self.player.position = CGPointMake(256, 256)
        self.player.zPosition = 10
        
        let wall = Wall()
        self.walls.append(wall)
        
        self.world.addChild(wall)
        self.world.addChild(self.player)
    }
    
    override func update(currentTime: NSTimeInterval) {
        if let lastUpdateTime = self.lastUpdateTime {
            self.dt = currentTime - lastUpdateTime
        } else {
            self.dt = 0
        }
        self.lastUpdateTime = currentTime
        
        self.player.update(self.dt)
        
        for wall in self.walls {
            wall.resolveCollisions(self.player)
        }
        
        if self.player.position.y < 0 {
            self.player.position = CGPointMake(256, 256)
        }
    }
    
    override func keyDown(theEvent: NSEvent) {
        switch Int(theEvent.charactersIgnoringModifiers!.utf16[0]) {
        case NSLeftArrowFunctionKey:
            self.player.left()
        case NSRightArrowFunctionKey:
            self.player.right()
        case NSUpArrowFunctionKey:
            self.player.jump(false)
        default:
            break
        }
        
        if theEvent.keyCode == 49 {
            self.player.jump(false)
        }
    }
    
    override func keyUp(theEvent: NSEvent) {
        switch Int(theEvent.charactersIgnoringModifiers!.utf16[0]) {
        case NSLeftArrowFunctionKey:
            self.player.stop()
        case NSRightArrowFunctionKey:
            self.player.stop()
        case NSUpArrowFunctionKey:
            self.player.jump(true)
        default:
            break
        }
        
        if theEvent.keyCode == 49 {
            self.player.jump(true)
        }
    }
}
