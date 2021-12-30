import UIKit
import SpriteKit
import GameplayKit

class ChainGameViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "ChainGameScene") as? ChainGameScene {

                scene.scaleMode = .resizeFill
                view.presentScene(scene)
            }
        }
    }
    
    
}
