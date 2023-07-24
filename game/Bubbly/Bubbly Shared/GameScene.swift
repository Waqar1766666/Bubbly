//
//  GameScene.swift
//  Bubbly Shared
//
//  Created by Waqar Ramzan on 23/07/2023.
//

import SpriteKit

class GameScene: SKScene {

    var timerLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var timerValue = 60 // Initial timer value
    var score = 0 // Player's score
    var isGameRunning = true // To check if the game is still running
    var level = 1 // Current level

    override func didMove(to view: SKView) {
        createTimerLabel()
        createScoreLabel()
        startTimer()
    }

    func createTimerLabel() {
        timerLabel = SKLabelNode(text: "Timer: \(timerValue)")
        timerLabel.position = CGPoint(x: frame.midX, y: frame.minY + 50)
        addChild(timerLabel)
    }

    func createScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 50)
        addChild(scoreLabel)
    }

    func startTimer() {
        let updateTimerAction = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.timerValue -= 1
            self.timerLabel.text = "Timer: \(self.timerValue)"
            if self.timerValue <= 0 {
                self.endGame()
            }
        }

        let waitAction = SKAction.wait(forDuration: 1)
        let sequenceAction = SKAction.sequence([waitAction, updateTimerAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        run(repeatAction)

        // Start creating bubbles after a short delay
        let startBubblesAction = SKAction.run { [weak self] in
            self?.createBubbles()
        }
        let initialDelayAction = SKAction.wait(forDuration: 2) // Adjust the delay time as needed
        run(SKAction.sequence([initialDelayAction, startBubblesAction]))
    }

    func createBubbles() {
        let bubbleSize = CGSize(width: 50, height: 50)
        
        // Create Blue Bubbles (2 points)
        let blueBubbleTexture = SKTexture(imageNamed: "BlueBubble") // Make sure you add "BlueBubble.png" to the asset catalog
        let blueBubble = SKSpriteNode(texture: blueBubbleTexture, size: bubbleSize)
        let randomX = CGFloat.random(in: frame.minX + 100 ... frame.maxX - 100)
        let randomY = CGFloat.random(in: frame.minY + 100 ... frame.maxY - 100)
        blueBubble.position = CGPoint(x: randomX, y: randomY)
        addChild(blueBubble)
        blueBubble.name = "bubble"
        blueBubble.physicsBody = SKPhysicsBody(circleOfRadius: bubbleSize.width / 2)
        blueBubble.physicsBody?.restitution = 1.0 // Make the bubble fully elastic (bounces off the screen)
        
        // Create Pink Bubbles (5 points)
        let pinkBubbleTexture = SKTexture(imageNamed: "PinkBubble") // Make sure you add "PinkBubble.png" to the asset catalog
        let pinkBubble = SKSpriteNode(texture: pinkBubbleTexture, size: bubbleSize)
        let randomX2 = CGFloat.random(in: frame.minX + 100 ... frame.maxX - 100)
        let randomY2 = CGFloat.random(in: frame.minY + 100 ... frame.maxY - 100)
        pinkBubble.position = CGPoint(x: randomX2, y: randomY2)
        addChild(pinkBubble)
        pinkBubble.name = "bubble"
        pinkBubble.physicsBody = SKPhysicsBody(circleOfRadius: bubbleSize.width / 2)
        pinkBubble.physicsBody?.restitution = 1.0 // Make the bubble fully elastic (bounces off the screen)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameRunning else { return }
        if let touch = touches.first {
            let location = touch.location(in: self)
            let tappedNodes = nodes(at: location)
            for node in tappedNodes {
                if node.name == "bubble" {
                    node.removeFromParent()
                    if node.texture?.description.contains("BlueBubble") ?? false {
                        // Blue Bubble Tapped (Add 2 points)
                        addScore(points: 2)
                    } else if node.texture?.description.contains("PinkBubble") ?? false {
                        // Pink Bubble Tapped (Add 5 points)
                        addScore(points: 5)
                    }
                }
            }
            if nodes(withName: "bubble").isEmpty {
                // All bubbles cleared, go to the next level
                nextLevel()
            }
        }
    }

    func addScore(points: Int) {
        score += points
        scoreLabel.text = "Score: \(score)"
    }

    func nextLevel() {
        // Reset the timer and increase the level
        timerValue = 60
        timerLabel.text = "Timer: \(timerValue)"
        level += 1
        
        // Increase bubble intensity for the next level (optional, customize as needed)
        // For example, you can add more bubbles or increase their speed.
        
        // Start creating bubbles for the next level
        createBubbles()
    }

    func endGame() {
        isGameRunning = false
        // Implement the logic for ending the game, e.g., showing a game-over screen or transitioning to the next level
    }
}

