//
//  GameOver.swift
//  Assignment1_Nguyen
//
//  Created by Tech on 2021-02-28.
//  Copyright © 2021 Tech. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOver: SKScene {
    var message:String = ""
    
    override func didMove(to view: SKView) {
        if let label = self.childNode(withName: "GameOverLabel") as? SKLabelNode
        {
            label.text = message
        }
    }
    
    
}
