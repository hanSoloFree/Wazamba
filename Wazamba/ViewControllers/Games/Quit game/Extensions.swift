import SpriteKit

extension SKAction {
    class func shake(initialPosition: CGPoint, duration: Float) -> SKAction {
        let amplitudeX: Int = 4
        let amplitudeY: Int = 4
        let startingX = initialPosition.x
        let startingY = initialPosition.y
        let numberOfShakes = duration / 0.03
        var actionsArray: [SKAction] = []
        for _ in 1...Int(numberOfShakes) {
            let newXPos = startingX + CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let newYPos = startingY + CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            actionsArray.append(SKAction.move(to: CGPoint(x: newXPos, y: newYPos), duration: 0.015))
        }
        actionsArray.append(SKAction.move(to: initialPosition, duration: 0.015))
        return SKAction.sequence(actionsArray)
    }
}

extension SKScene {
     func countBlocks(_ level: Int) -> Int {
        switch level {
        case 1:
            return 2
        case 2:
            return 3
        case 3:
            return 5
        case 4:
            return 6
        case 5:
            return 7
        case 6:
            return 9
        case 7:
            return 10
        default:
            return 0
        }
    }
}

extension RestoreGameScene {
    func timeToRemember(_ level: Int) -> Int {
        switch level {
        case 1...2:
            return 3
        case 3...4:
            return 6
        case 5:
            return 7
        case 6...7:
            return 9
        default:
            return 5
        }
    }
    
    func physicsBody(for block: SKSpriteNode, isOn: Bool) {
        block.physicsBody?.affectedByGravity = isOn
        block.physicsBody?.allowsRotation = isOn
        block.physicsBody?.isDynamic = isOn
    }
    
    func checkIfBlockIsInTheFrame(_ block: SKSpriteNode, array: [SKSpriteNode]) -> Bool {
        for i in array {
            if i == block {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func getFiiledFrameAccordingToBlock(_ block: SKSpriteNode, array: [SKSpriteNode]) -> SKSpriteNode {
        for filledFrame in array {
            let blockIsInTheFrame: Bool = ((filledFrame.position.y < block.frame.maxY) && (filledFrame.position.y > block.frame.minY)) && ((filledFrame.position.x < block.frame.maxX) && (filledFrame.position.x > block.frame.minX))
            
            if blockIsInTheFrame {
                return filledFrame
            }
        }
        return SKSpriteNode()
    }
}


extension CGFloat {
    static func module(_ a: CGFloat) -> CGFloat {
        return sqrt(a*a)
    }
}
