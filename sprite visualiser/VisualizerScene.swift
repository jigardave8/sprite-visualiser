//
//  VisualizerScene.swift
//  sprite visualiser
//
//  Created by Jigar on 17/06/24.
//

import SpriteKit

class VisualizerScene: SKScene {
    private var particleEmitter: SKEmitterNode?
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        createParticleEffect()
    }
    
    func createParticleEffect() {
        if let emitter = SKEmitterNode(fileNamed: "Particle.sks") {
            emitter.position = CGPoint(x: size.width / 2, y: size.height / 2)
            addChild(emitter)
            particleEmitter = emitter
        }
    }
    
    func updateVisualizer(with level: CGFloat) {
        particleEmitter?.particleBirthRate = level * 10
    }
}
