import UIKit
import SpriteKit
import GameplayKit

class QuitGameViewController: BaseViewController, GameOverDelegate {
    
    var won: Bool?
    var level: Int!
    var currentLevel: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "QuitGameScene") as? QuitGameScene {
                
                scene.level = level
                scene.gameOverDelegate = self
                scene.scaleMode = .resizeFill
                view.presentScene(scene)
            }
        }
    }
    
    func pushGameOverViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let gameOverViewController = storyboard.instantiateViewController(withIdentifier: "GameOverViewController") as? GameOverViewController else { return }
        
        gameOverViewController.game = "quit"
        gameOverViewController.won = self.won
        gameOverViewController.currentLevel = self.currentLevel
        self.navigationController?.pushViewController(gameOverViewController, animated: true)
    }
}
