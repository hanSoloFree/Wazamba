import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameOverDelegate: GameOverDelegate?
    
    var background: SKSpriteNode!
    var ground: SKSpriteNode!
    
    var timerCountdown: Int! {
        didSet {
            guard let time = timerCountdown else { return }
            timer.text = String(describing: time)
        }
    }
    var gameStartTimerCountdown: Int! {
        didSet {
            guard let time = gameStartTimerCountdown else { return }
            gameStartTimer.text = String(describing: time)
        }
    }
    
    var timer: SKLabelNode!
    var gameStartTimer: SKLabelNode!
    
    var blocksCount: Int {
        return countBlocks(level)
    }
    
    
    
    var blocksArray: [SKSpriteNode] = [SKSpriteNode]()
    var currentTimeBlocksArray: [SKSpriteNode] = [SKSpriteNode]()
    var blocksInTheFrame: [SKSpriteNode] = [SKSpriteNode]()
    
    
    var framesArray: [SKSpriteNode] = [SKSpriteNode]()
    var filledFramesArray:[SKSpriteNode] = [SKSpriteNode]()
    
    
    var startingPositions: [CGPoint] = [CGPoint]()
    

    var blocksInTheirStartingPositions: Int = 0
    
    
    //MARK: - LEVEL
    var level: Int = 7
    
    var gameStarted: Bool = false
    
    var timerShouldStart: Bool = false
    var timerStarted: Bool = false

    
    
    
    var blockIsSelected: Bool = false
    var blockIsInTheFrame: Bool = false
    
    
    var selectedBlock: SKSpriteNode?
    var selectedName: String?
    
    var blockStartingSize: CGSize!
    
    
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        createGameStartTimer()
        
        createBackground()
        createTimer()
        createBlocks()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted {
            
            guard let touchLocation = touches.first?.location(in: self) else { return }
            
                                    //MARK: - TOUCH ON BLOCK!
            for block in blocksArray {
                let blockIsTouched: Bool = ((touchLocation.x > block.frame.minX + 3) && (touchLocation.x < block.frame.maxX - 3)) && ((touchLocation.y > block.frame.minY + 3) && (touchLocation.y < block.frame.maxY - 3))
            
                
                                    //MARK: SIMMILAR CONDITIONS
                
                
                
                if blockIsTouched && !blockIsSelected  {
                                            //MARK: SELECT

                    if !checkIfBlockIsInTheFrame(block) && block.physicsBody!.affectedByGravity {
                    
                    guard let name = block.name else { return }

                    
                    
                    let selectedTexture = SKTexture(imageNamed: name + "s")
                    
                    let newTextureAction = SKAction.setTexture(selectedTexture)
                    let scaleAction = SKAction.scale(by: 1.1, duration: 0.2)
                    let actionsGroup = SKAction.group([newTextureAction, scaleAction])
                    
                        block.run(actionsGroup) {
                            self.selectedBlock = block
                            self.selectedName = name
                            self.blockIsSelected = true
                        }
                    } else {
                                        //MARK: DROP FROM THE FRAME
                        
                        
                        removeFromBlocksInTheFrames(block)
                        let filledFrame = getFiiledFrameAccordingToBlock(block)
                        removeFromFilledFrames(filledFrame)
                        
                        
                        
                        block.physicsBody?.affectedByGravity = true
                        block.physicsBody?.allowsRotation = true
                        block.physicsBody?.isDynamic = true
                        block.physicsBody?.categoryBitMask = 0x1 << 0
                        block.zPosition = 9
                        
                    }
                }
                
                                //MARK: DESELECT
                
                if   blockIsSelected && !checkIfBlockIsInTheFrame(block) && block.physicsBody!.affectedByGravity {
                    
                    guard let size = blockStartingSize else { return }
                    guard let name = block.name else { return }

                    
                    
                    let scaleAction = SKAction.scale(to: size, duration: 0.2)
            
                    let oldTexture = SKTexture(imageNamed: name)
                    
                    let oldTextureAction = SKAction.setTexture(oldTexture)
                            
                    let actionsGroup = SKAction.group([scaleAction, oldTextureAction])
                    
                    block.run(actionsGroup) {
                        
                        
                        
                        self.blockIsSelected = false
                        self.selectedName = nil
                        self.selectedBlock = nil
                        
                        
                        block.physicsBody?.affectedByGravity = true
                        block.physicsBody?.allowsRotation = true
                        block.physicsBody?.isDynamic = true
                        block.physicsBody?.categoryBitMask = 0x1 << 0
                        block.zPosition = 10
                    }
                    
                    
                }
                
                
            }
            
                            
                                    //MARK: - TOUCH ON FRAME!
            
            
            for frame in framesArray {
                let frameIsTouched: Bool = ((touchLocation.x > frame.frame.minX) && (touchLocation.x < frame.frame.maxX)) && ((touchLocation.y > frame.frame.minY) && (touchLocation.y < frame.frame.maxY))
            
                                    //MARK: MOVE TO FRAME
                
                if frameIsTouched && blockIsSelected && !filledFramesArray.contains(frame) {
                    guard let block = selectedBlock else { return }
                    guard let name = block.name else { return }
                    guard let size = blockStartingSize else { return }
                
                    let moveToFrameAction = SKAction.move(to: frame.position, duration: 0.2)
                    let resizeActiton = SKAction.scale(to: size, duration: 0.2)
                                                    
                    let normalTexture = SKTexture(imageNamed: name)
                    let textureAction = SKAction.setTexture(normalTexture)
                    
                    let actionsGroup = SKAction.group([moveToFrameAction, resizeActiton, textureAction])
                    
                    block.run(actionsGroup) {
                        self.filledFramesArray.append(frame)
                        self.blocksInTheFrame.append(block)
                        
                        self.selectedName = nil
                        self.selectedBlock = nil
                        self.blockIsSelected = false
                        
                        
                        block.zRotation = 0
                        block.physicsBody?.affectedByGravity = false
                        block.physicsBody?.allowsRotation = false
                        block.physicsBody?.isDynamic = false
                        block.physicsBody?.categoryBitMask = 0x0 << 0
                    }
            
                }
            }
        }
    }
    
    
    func checkIfBlockIsInTheFrame(_ block: SKSpriteNode) -> Bool {
        for i in blocksInTheFrame {
            if i == block {
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func getFiiledFrameAccordingToBlock(_ block: SKSpriteNode) -> SKSpriteNode {
        for filledFrame in filledFramesArray {
            let blockIsInTheFrame: Bool = ((filledFrame.position.y < block.frame.maxY) && (filledFrame.position.y > block.frame.minY)) && ((filledFrame.position.x < block.frame.maxX) && (filledFrame.position.x > block.frame.minX))
            
            if blockIsInTheFrame {
                return filledFrame
            }
        }
        return SKSpriteNode()
    }
    
    func removeFromFilledFrames(_ frame: SKSpriteNode) {
        var index = 0
        for i in filledFramesArray {
            if i == frame {
                filledFramesArray.remove(at: index)
                return
            }
            index += 1
        }
    }
    
    func removeFromBlocksInTheFrames(_ block: SKSpriteNode) {
        var index = 0
        for i in blocksInTheFrame {
            if i == block {
                blocksInTheFrame.remove(at: index)
                return
            }
            index += 1
        }
    }
    
    func getIndexInFilledFrames(_ frame: SKSpriteNode) -> Int {
        var index = 0
        for i in filledFramesArray {
            if i == frame {
                return index
            }
            index += 1
        }
        return -1
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        if timerShouldStart && !timerStarted {
            timerStarted = true
            timerShouldStart = false
            timer.alpha = 1
            startTimer()
            checkIfWon()
        }
    }
    

    
    
    func checkIfWon() {
        var index = 0
        currentTimeBlocksArray.removeAll()
        blocksInTheirStartingPositions = 0
        for item in blocksArray {
            currentTimeBlocksArray.append(item)
        }
        for item in currentTimeBlocksArray {
            let startingPosition = self.startingPositions[index]
            let currentPosition = item.position
            
            let diffferenceX = module(startingPosition.x) - module(currentPosition.x)
            let diffferenceY = module(startingPosition.y) - module(currentPosition.y)
            
            if (diffferenceX < 0.1) && (diffferenceY < 0.1) {
                self.blocksInTheirStartingPositions += 1
            }
            index += 1
        }
        if blocksInTheirStartingPositions == blocksArray.count {
            isPaused = true
            self.removeAction(forKey: "countdown")
            gameOverDelegate?.won = true
            gameOverDelegate?.pushGameOverViewController()
        }
    }
    
    
    // MARK: - MAY BE INCAPSULATED
    
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
        
        ground.physicsBody?.categoryBitMask =  0x1 << 2
        ground.physicsBody?.contactTestBitMask = 0x1 << 1
        
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
        let deviceScreen = self.frame.width / self.frame.height
        var blocksForLine: Int!
        var horizontalSpacing: CGFloat!
        var verticalSpacing: CGFloat!
        
        
        let blockHeight = (self.frame.height / 15)
        
        var index = 0
        
        
        switch lineNumber {
        case 1:
            index = 0
            if blocksCount >= 3 {
                horizontalSpacing = self.frame.width / 5.3
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
                horizontalSpacing = self.frame.width / 8
            } else if blocksCount == 6 {
                blocksForLine = blocksCount - 3
                horizontalSpacing = self.frame.width / 5.3
            } else {
                blocksForLine = 2
                horizontalSpacing = self.frame.width / 3.8
            }
            verticalSpacing = blockHeight + 20.0
        case 3:
            index = 7
            if blocksCount == 8 {
                blocksForLine = 1
                horizontalSpacing =  self.frame.width / 3
            } else if blocksCount == 9{
                blocksForLine = 2
                horizontalSpacing = self.frame.width / 3.8
            } else if blocksCount == 10 {
                blocksForLine = 3
                horizontalSpacing = self.frame.width / 5.3
            }
            verticalSpacing = 2 * (blockHeight + 20.0)
            
        default:
            break
        }

        
        
        // MARK: BLOCK
        
        for _ in 1...blocksForLine {
            
            if deviceScreen > 0.5 {
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
            block.physicsBody?.categoryBitMask = 0x1 << 0
            block.physicsBody?.contactTestBitMask = 0x1 << 0
            
            block.physicsBody?.allowsRotation = false
            block.physicsBody?.isDynamic = false
            block.physicsBody?.affectedByGravity = false
            block.physicsBody?.pinned = true
            

            blockStartingSize = block.size
            startingPositions.append(block.position)
            blocksArray.append(block)
            addChild(block)
            
            //MARK: BLOCK'S FRAME
            
            let frame = SKSpriteNode(imageNamed: "frame")
            frame.size = CGSize(width: blockHeight + 10, height: blockHeight + 10)
            frame.position = CGPoint(x: x, y: y)
            frame.zPosition = 9
            framesArray.append(frame)
            addChild(frame)
        }
    }
    
    //MARK: CORNER TIMER
    
    
    func createTimer() {
        timer = SKLabelNode(fontNamed: "Arial Rounded MT Bold")
        let position = CGPoint(x: (self.frame.width / 2) - 60,
                               y: (self.frame.height / 2) - 60)
        
        timer.fontSize = (self.frame.width / 10.35)
        timer.position = position
        timer.alpha = 0
        
        switch level {
        case 1...2:
            timerCountdown = 6
        case 3...5:
            timerCountdown = 20
        case 6:
            timerCountdown = 45
        case 7:
            timerCountdown = 60
        default:
            timerCountdown = 15
        }
        guard let time = timerCountdown else { return }
        timer.text = String(describing: time)
        
        addChild(timer)
    }
    
    func startTimer() {
        let timerAction = SKAction.wait(forDuration: 1)
        let block = SKAction.run {
            if self.timerCountdown > 0 {
                self.timerCountdown -= 1
            } else {
                self.gameOverDelegate?.won = false
                self.gameOverDelegate?.pushGameOverViewController()
                self.removeAction(forKey: "countdown")
            }
        }
        let sequence = SKAction.sequence([timerAction, block])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction, withKey: "countdown")
    }
    
    
    //MARK: GAME STARTING TIMER
    
    
    func createGameStartTimer() {
        gameStartTimer = SKLabelNode(fontNamed: "Arial Rounded MT Bold")
        gameStartTimer.position = CGPoint(x: 0, y: 0)
        gameStartTimer.fontSize = 60
        gameStartTimer.zPosition = 20
        
        gameStartTimerCountdown = 5
        
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
                self.blocksArray.forEach { block in
                    
                    block.physicsBody?.allowsRotation = true
                    block.physicsBody?.isDynamic = true
                    block.physicsBody?.affectedByGravity = true
                    block.physicsBody?.pinned = false
                    
                    let randomX = CGFloat.random(in: -200...200)
                    
                    let impulse = CGVector(dx: randomX, dy: 150)
                    
                    block.physicsBody?.applyImpulse(impulse)
                }
                self.gameStartTimer.removeFromParent()
                self.removeAction(forKey: "gameStartCountdown")
                self.gameStarted = true
            }
        }
        let sequence = SKAction.sequence([timerAction, block])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction, withKey: "gameStartCountdown")
    }
    
    
    
    
    
    
    
    func module(_ a: CGFloat) -> CGFloat {
        return sqrt(a*a)
    }
}
