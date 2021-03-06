import SpriteKit
import GameplayKit

class ChainGameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameOverDelegate: GameOverDelegate?
    
    var aspectRatio: CGFloat!
    
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
    
    var index: Int = -1 {
        didSet {
            chain[index].run(blinkAction)
        }
    }
    
    var background: SKSpriteNode!
    var ground: SKSpriteNode!
    
    var timer: SKLabelNode!
    var gameStartTimer: SKLabelNode!
    
    var gameStarted: Bool = false
    
    var blocksCount: Int! {
        return countBlocks(level)
    }
    
    var blocksArray: [SKSpriteNode] = [SKSpriteNode]()
    var chain: [SKSpriteNode] = [SKSpriteNode]()
    
    var coins: [SKSpriteNode] = [SKSpriteNode]()
    
    var touchedCount: Int = 0 {
        didSet {
            if touchedCount == blocksCount {
                dropCoins()
                self.run(.wait(forDuration: 1)) {
                    self.gameStarted = false
                    self.gameOverDelegate?.won = true
                    self.gameOverDelegate?.currentLevel = self.level
                    self.gameOverDelegate?.pushGameOverViewController()
                }
            }
        }
    }
    
    var blinkAction: SKAction {
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        
        let sequence = SKAction.sequence([fadeOut, fadeIn])
        
        return sequence
    }
    
    //MARK: LEVEL
    
    var level: Int!
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        aspectRatio = self.frame.width / self.frame.height
        
        createBlocks()
        createBackground()
        
        createGameStartTimer()
    }
    

                                    //MARK: - TOUCH LOGIC
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted {
            for block in chain {
                guard let touchLocation = touches.first?.location(in: self) else { return }
                
                let blockIsTouched: Bool = ((touchLocation.x > block.frame.minX) && (touchLocation.x < block.frame.maxX)) && ((touchLocation.y > block.frame.minY) && (touchLocation.y < block.frame.maxY))
                
                if blockIsTouched {
                    if block == chain.first {
                        self.remove(block)
                    } else {
                        chain.forEach { block in
                            block.physicsBody?.affectedByGravity = true
                            block.physicsBody?.isDynamic = true
                            let randomX = CGFloat.random(in: -50...50)
                            let randomY = CGFloat.random(in: -50...50)
                            let vector = CGVector(dx: randomX, dy: randomY)
                            block.physicsBody?.applyImpulse(vector)
                        }
                    }
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard gameStarted else { return }
        
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if ((bodyA.categoryBitMask == 0x1 << 1) && (bodyB.categoryBitMask == 0x1 << 2)) || ((bodyA.categoryBitMask == 0x1 << 2) && (bodyB.categoryBitMask == 0x1 << 1)) {
            let sound = SKAction.playSoundFileNamed("loseSound", waitForCompletion: false)
            self.run(sound)
            gameOverDelegate?.won = false
            gameOverDelegate?.pushGameOverViewController()
            gameStarted = false
        }
    }
    
    func remove(_ block: SKSpriteNode) {
        let scaleAction = SKAction.scale(by: 0, duration: 0.4)
        self.chain.removeFirst()
        block.run(scaleAction) {
            block.removeFromParent()
            self.touchedCount += 1
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
        
        //MARK: BORDERS
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.background.frame)
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
        DispatchQueue.global().async {
            for _ in 1...Int.random(in: 6...8) {
                self.createCoin()
            }
        }
        startBlinking()
    }
    
    func startBlinking() {
        let block = SKAction.run {
            guard self.index < self.chain.count - 1 else {
                self.removeAction(forKey: "blinking")
                self.showStartLabel()
                self.gameStarted = true
                return
            }
            self.index += 1
        }
        let wait = SKAction.wait(forDuration: 0.5)
        
        let sequence = SKAction.sequence([block, wait])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction, withKey: "blinking")
    }
    
    func showStartLabel() {
        self.gameStartTimer.text = "Start!"
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let wait = SKAction.wait(forDuration: 1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let sequence = SKAction.sequence([fadeIn, wait, fadeOut])
        self.gameStartTimer.run(sequence) {
            self.gameStartTimer.isHidden = true
            self.timer.alpha = 1
            self.startTimer()
        }
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
                self.gameStartTimer.alpha = 0
                self.removeAction(forKey: "gameStartCountdown")
                self.createTimer()
                DispatchQueue.global().async {
                    self.createChain()
                }
            }
        }
        let sequence = SKAction.sequence([timerAction, block])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction, withKey: "gameStartCountdown")
    }
    
    func createTimer() {
        DispatchQueue.global().async {
            self.timer = SKLabelNode(fontNamed: "Arial Rounded MT Bold")
            var y:CGFloat = 100
            if self.aspectRatio > 0.5 { y = 60 }
            
            let position = CGPoint(x: (self.frame.width / 2) - 60,
                                   y: (self.frame.height / 2) - y)
            
            self.timer.fontSize = (self.frame.width / 10.35)
            self.timer.position = position
            self.timer.alpha = 0
            
            self.timerCountdown = 10
            guard let time = self.timerCountdown else { return }
            self.timer.text = String(describing: time)
            
            self.addChild(self.timer)
        }
    }
    
    func startTimer() {
        let timerAction = SKAction.wait(forDuration: 1)
        let block = SKAction.run {
            if self.timerCountdown > 0 {
                self.timerCountdown -= 1
            } else {
                guard self.gameStarted else { return }
                let sound = SKAction.playSoundFileNamed("loseSound", waitForCompletion: false)
                self.run(sound)
                self.gameOverDelegate?.won = false
                self.gameOverDelegate?.pushGameOverViewController()
                self.removeAction(forKey: "countdown")
            }
        }
        let sequence = SKAction.sequence([timerAction, block])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction, withKey: "countdown")
    }
    
    func createCoin() {
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.size = CGSize(width: 40, height: 40)
        guard let last = chain.last else { return }
        coin.position = CGPoint(x: last.position.x, y: last.position.y)
        coin.zPosition = 20
        coin.physicsBody = SKPhysicsBody(texture: coin.texture!, size: coin.size)
        coin.physicsBody?.affectedByGravity = true
        coin.physicsBody?.isDynamic = true
        
        self.coins.append(coin)
    }
    
    func dropCoins() {
        self.coins.forEach { coin in
            self.addChild(coin)

            let randomX = CGFloat.random(in: -20...20)
            let vector = CGVector(dx: randomX, dy: 10)
                        
            coin.physicsBody?.pinned = false
            coin.physicsBody?.applyImpulse(vector)
        }
        coinSound()
    }
    
    func coinSound() {
        let sound = SKAction.playSoundFileNamed("coinDrop", waitForCompletion: false)
        let group = SKAction.group([sound, sound, sound])
        self.run(group)
    }
}
