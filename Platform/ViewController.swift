//
//  ViewController.swift
//  Platform
//
//  Created by Aaron Wright on 3/30/15.
//  Copyright (c) 2015 Aaron Wright. All rights reserved.
//

import SpriteKit

class ViewController: NSViewController {
    
    @IBOutlet weak var gameView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.gameView.ignoresSiblingOrder = true
        self.gameView.showsFPS = true
        self.gameView.showsNodeCount = true
        
        let scene = Scene(size: self.gameView.bounds.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        
        self.gameView.presentScene(scene)
    }


}

