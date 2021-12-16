import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background: SKSpriteNode!
    var ground: SKSpriteNode!
    var blocksCount: Int {
        return countBlocks(level)
    }
    var blocksArray: [SKSpriteNode] = [SKSpriteNode]()
    
    
    //MARK: - LEVEL
    var level: Int = 6
    
    var forced: Bool = false
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity.dy = gravity(self.level)
        
        print(blocksCount)
        
        createBackground()
        createBlocks()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB

        
        if (bodyA.categoryBitMask == 0x1 << 0) && (bodyB.categoryBitMask == 0x1 << 0) {
            if !forced {
                self.physicsWorld.gravity.dy = -9.8
                let randomX = CGFloat.random(in: -50...50)
                let impulse = CGVector(dx: randomX, dy: 50)
                bodyA.node?.physicsBody?.applyImpulse(impulse)
                bodyB.node?.physicsBody?.applyImpulse(impulse)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                    self.forced = true
                }
            }
        }
    }
    
// MARK: - MAY BE INCAPSULATED
    
    func gravity(_ level: Int) -> CGFloat {
        switch level {
        case 1...3:
            return -9
        case 3...5:
            return -5
        case 6...7:
            return -2
        default:
            return -9.8
        }
    }
    func countBlocks(_ level: Int) -> Int {
        switch level {
        case 1:
            return 2
        case 2:
            return 3
        case 3:
            return Int.random(in: 4...5)
        case 4:
            return 6
        case 5:
            return Int.random(in: 7...8)
        case 6:
            return 9
        case 7:
            return 10
        default:
            return 0
        }
    }
    
    
    func createBackground() {
        // MARK: BACKGROUND
        background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.zPosition = 0
        
        addChild(background)

        // MARK: GROUND
        ground = SKSpriteNode(imageNamed: "ground")
        let width = self.frame.width + 25
        let height = 150.0
        ground.size = CGSize(width: width, height: height)
        let y = -(self.frame.height / 2) + (height / 2)
        ground.position = CGPoint(x: 0, y: y)
        ground.zPosition = 1
        
        ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.pinned = false
        
        addChild(ground)
        
        //MARK: BORDERS
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    func createBlocks() {
        //MARK: LINES OF BLOCKS

        if (blocksCount > 0) && (blocksCount <= 3) {
            buildLine(lineNumber: 1)
        }
        
        
        if (blocksCount > 3) && (blocksCount <= 7) {
            buildLine(lineNumber: 1)
            buildLine(lineNumber: 2)
        }
        
        if (blocksCount > 7) && (blocksCount <= 10) {
            buildLine(lineNumber: 1)
            buildLine(lineNumber: 2)
            buildLine(lineNumber: 3)
        }


    }
    
    // MARK: LINE
    func buildLine(lineNumber: Int) {
        var blockPerLine: Int!
        var horizontalSpacing: CGFloat!
        var verticalSpacing: CGFloat!
        
        let blockHeight = (self.frame.height / 15)
        
        var index = 0
        
        switch lineNumber {
        case 1:
            index = 0
            if blocksCount > 3 {
                blockPerLine = 3
            } else {
                blockPerLine = blocksCount
            }
            horizontalSpacing = 30.0
            verticalSpacing = 0.0
        case 2:
            index = 3
            blockPerLine = blocksCount - 3
            horizontalSpacing = 20.0
            verticalSpacing = blockHeight + horizontalSpacing
        case 3:
            index = 7
            blockPerLine = blocksCount - 7
            horizontalSpacing = 40.0
            verticalSpacing = 2 * (blockHeight + horizontalSpacing)
            
        default:
            break
        }
        
        // MARK: BLOCK
        
        for _ in 1...blockPerLine {
            index += 1
            let block = SKSpriteNode(imageNamed: String(describing: index))
            
            block.size = CGSize(width: blockHeight, height: blockHeight)
            
            let x = -(self.frame.width / 2) + (horizontalSpacing * 1.5)
            let y = (self.frame.height / 3) - verticalSpacing
            block.position = CGPoint(x: x, y: y)
            block.zPosition = 10
            
            horizontalSpacing += block.size.width
            
            block.physicsBody = SKPhysicsBody(texture: block.texture!, size: block.size)
            block.physicsBody?.categoryBitMask = 0x1 << 0
            block.physicsBody?.contactTestBitMask = 0x1 << 0
            
            blocksArray.append(block)
            addChild(block)
            
            //MARK: BLOCK'S FRAME
            
            let frame = SKSpriteNode(imageNamed: "frame")
            frame.size = CGSize(width: blockHeight + 10, height: blockHeight + 10)
            frame.position = CGPoint(x: x, y: y)
            frame.zPosition = 9
            addChild(frame)
        }
    }
    
}
