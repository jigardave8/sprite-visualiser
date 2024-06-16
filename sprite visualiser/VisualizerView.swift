//
//  VisualizerView.swift
//  sprite visualiser
//
//  Created by Jigar on 17/06/24.
//

import SwiftUI
import SpriteKit

struct VisualizerView: UIViewRepresentable {
    var scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.presentScene(scene)
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Update the view if needed
    }
}
