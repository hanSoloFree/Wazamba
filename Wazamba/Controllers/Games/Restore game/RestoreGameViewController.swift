import UIKit
import SpriteKit
import GameplayKit

class RestoreGameViewController: BaseViewController, GameOverDelegate {

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
            if let scene = SKScene(fileNamed: "RestoreGameScene") as? RestoreGameScene {
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
        gameOverViewController.levelUpDelegate = self
        
        gameOverViewController.game = "restore"
        gameOverViewController.won = self.won
        gameOverViewController.currentLevel = self.currentLevel
        self.present(gameOverViewController, animated: true)
    }
}

extension RestoreGameViewController: LevelUpDelegate {
    func levelUp() {
        self.level += 1
    }
}
