import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background: SKSpriteNode!
    var ground: SKSpriteNode!
    var blocksCount: Int = 10
    var blocksArray: [SKSpriteNode] = [SKSpriteNode]()
    
    //MARK: - MIX TIME
    
    var mixTime = DispatchTime.now() + 2
    
    var forced: Bool = false
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        createBackground()
        createBlocks()
        
        print(self.frame.height / 64)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask == 0x1 << 0) && (bodyB.categoryBitMask == 0x1 << 0) {
            if !forced {
                let randomX = CGFloat.random(in: -50...50)
                let impulse = CGVector(dx: randomX, dy: 50)
                bodyA.node?.physicsBody?.applyImpulse(impulse)
                bodyB.node?.physicsBody?.applyImpulse(impulse)
                DispatchQueue.main.asyncAfter(deadline: mixTime) {
                    self.forced = true
                }
            }
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
        //MARK: BLOCK
        

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
        }
    }
    
}
