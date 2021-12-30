import SpriteKit
import GameplayKit

class ChainGameScene: SKScene, SKPhysicsContactDelegate {
    
    var aspectRatio: CGFloat!

    var gameStartTimerCountdown: Int! {
        didSet {
            guard let time = gameStartTimerCountdown else { return }
            gameStartTimer.text = String(describing: time)
        }
    }
    
    var index: Int = -1 {
        didSet {
            chain[index].run(blinkAction)
        }
    }
    
    var blinkAction: SKAction {
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        
        let sequence = SKAction.sequence([fadeOut, fadeIn])
        
        return sequence
    }
    
    var background: SKSpriteNode!
    var ground: SKSpriteNode!
    
    var gameStartTimer: SKLabelNode!
    
    var blocksCount: Int! {
        return countBlocks(level)
    }
    
    var blocksArray: [SKSpriteNode] = [SKSpriteNode]()
    var chain: [SKSpriteNode] = [SKSpriteNode]()
    
    var level: Int = 3
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        physicsWorld.contactDelegate = self
        aspectRatio = self.frame.width / self.frame.height
        
        createGameStartTimer()
        
        createBackground()
        createBlocks()
    }
    
    func createBackground() {
        // MARK: BACKGROUND
        background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.zPosition = 0
        
        addChild(background)
        
        // MARK: GROUND
        ground = SKSpriteNode(imageNamed: "ground")
        let width = self.frame.width
        let height = width / 3.45
        ground.size = CGSize(width: width, height: height)
        let y = -(self.frame.height / 2) + (height / 2)
        ground.position = CGPoint(x: 0, y: y)
        ground.zPosition = 1
        
        ground.physicsBody = SKPhysicsBody(texture: ground.texture!, size: ground.size)
        
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.pinned = true
        
        ground.physicsBody?.categoryBitMask =  0x1 << 2
        ground.physicsBody?.contactTestBitMask = 0x1 << 1
        
        addChild(ground)
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
    
    func buildLine(lineNumber: Int) {
        var blocksForLine: Int!
        var horizontalSpacing: CGFloat!
        var verticalSpacing: CGFloat!
        
        let blockHeight: CGFloat = (self.frame.height / 14)
        
        var index = 0
        
        switch lineNumber {
        case 1:
            index = 0
            if blocksCount >= 3 {
                horizontalSpacing = self.frame.width / 5.5
                blocksForLine = 3
            } else {
                horizontalSpacing = self.frame.width / 3.8
                blocksForLine = blocksCount
            }
            verticalSpacing = 0.0
        case 2:
            index = 3
            if blocksCount >= 7 {
                blocksForLine = 4
                horizontalSpacing = self.frame.width / 9
            } else if blocksCount == 6 {
                blocksForLine = blocksCount - 3
                horizontalSpacing = self.frame.width / 5.5
            } else {
                blocksForLine = 2
                horizontalSpacing = self.frame.width / 3.8
            }
            verticalSpacing = blockHeight + 20.0
        case 3:
            index = 7
            if blocksCount == 8 {
                blocksForLine = 1
                horizontalSpacing =  self.frame.width / 2.8
            } else if blocksCount == 9{
                blocksForLine = 2
                horizontalSpacing = self.frame.width / 3.8
            } else if blocksCount == 10 {
                blocksForLine = 3
                horizontalSpacing = self.frame.width / 5.5
            }
            verticalSpacing = 2 * (blockHeight + 20.0)
            
        default:
            break
        }

        
        
        // MARK: BLOCK
        
        for _ in 1...blocksForLine {
            
            if aspectRatio > 0.5 {
                horizontalSpacing += 5
            }

            index += 1
            let name = String(describing: index)
            let block = SKSpriteNode(imageNamed: name)
            block.name = name
            
            block.size = CGSize(width: blockHeight, height: blockHeight)
            
            let x = -(self.frame.width / 2) + (horizontalSpacing * 1.5)
            let y = (self.frame.height / 3) - verticalSpacing
            block.position = CGPoint(x: x, y: y)
            block.zPosition = 10
            
            horizontalSpacing += block.size.width
            
            block.physicsBody = SKPhysicsBody(texture: block.texture!, size: block.size)
            block.physicsBody?.isDynamic = false
            block.physicsBody?.affectedByGravity = false
            block.physicsBody?.allowsRotation = false
            block.physicsBody?.pinned = true
            
            block.physicsBody?.categoryBitMask = 0x1 << 1
            block.physicsBody?.contactTestBitMask = 0x1 << 2
                        
            addChild(block)
            
            self.blocksArray.append(block)
        }
    }
    
    //MARK: CHAIN
    
    func createChain() {
        guard !(blocksArray.isEmpty) else { return }
        for _ in 1...blocksArray.count {
            let randomIndex = Int.random(in: 1...blocksArray.count) - 1
            let block = blocksArray[randomIndex]
            
            blocksArray.remove(at: randomIndex)
            chain.append(block)
        }
        startBlinking()
    }
    
    func startBlinking() {
        let block = SKAction.run {
            guard self.index < self.chain.count - 1 else {
                self.removeAction(forKey: "blinking")
                return
            }
            self.index += 1
        }
        let wait = SKAction.wait(forDuration: 1.0)
        
        let sequence = SKAction.sequence([block, wait])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction, withKey: "blinking")
    }

    //MARK: GAME STARTING TIMER
    
    func createGameStartTimer() {
        gameStartTimer = SKLabelNode(fontNamed: "Arial Rounded MT Bold")
        gameStartTimer.position = CGPoint(x: 0, y: 0)
        gameStartTimer.fontSize = 60
        gameStartTimer.zPosition = 20
        
        gameStartTimerCountdown = 3
        
        guard let time = gameStartTimerCountdown else { return }
        
        gameStartTimer.text = String(describing: time)
        addChild(gameStartTimer)
        startGameStartTimer()
    }
    
    func startGameStartTimer() {
        let timerAction = SKAction.wait(forDuration: 1)
        let block = SKAction.run {
            if self.gameStartTimerCountdown > 0 {
                self.gameStartTimerCountdown -= 1
            } else {
                self.gameStartTimer.isHidden = true
                self.gameStartTimer.removeAllActions()
                self.createChain()
            }
        }
        let sequence = SKAction.sequence([timerAction, block])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction, withKey: "gameStartCountdown")
    }
}





extension ChainGameScene {
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
