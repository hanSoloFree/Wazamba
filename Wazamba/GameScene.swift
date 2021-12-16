import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var background: SKSpriteNode!
    var ground: SKSpriteNode!
    var blocksCount: Int = 3
    var blocksArray: [SKSpriteNode] = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        createBackground()
        createBlock()
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
    
    func createBlock() {
        //MARK: BLOCK
        
        var spacing = 30.0
        var index = 0
        for _ in 1...blocksCount {
            index += 1
            let block = SKSpriteNode(imageNamed: String(describing: index))
            let height = self.frame.width / 5.75
            block.size = CGSize(width: height, height: height)
            
            let x = -(self.frame.width / 2) + (spacing * 1.5)
            let y = (self.frame.height / 3)
            block.position = CGPoint(x: x, y: y)
            block.zPosition = 10
            
            spacing += block.size.width
            
            block.physicsBody = SKPhysicsBody(texture: block.texture!, size: block.size)
            
            blocksArray.append(block)
            addChild(block)
        }

    }
    
   
}
