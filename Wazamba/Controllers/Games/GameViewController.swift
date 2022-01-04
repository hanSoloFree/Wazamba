import UIKit
import SpriteKit
import GameplayKit

class GameViewController: BaseViewController, GameOverDelegate {

    var won: Bool?
    var level: Int!
    var currentLevel: Int?
    var game: String!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackImage()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       setupScene()
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
  
    func setupScene() {
        switch game {
        case "restore":
            if let view = self.view as! SKView? {
                if let scene = SKScene(fileNamed: "RestoreGameScene") as? RestoreGameScene {
                    scene.level = level
                    scene.gameOverDelegate = self
                    scene.scaleMode = .resizeFill
                    view.presentScene(scene)
                }
            }
        case "chain":
            if let view = self.view as! SKView? {
                if let scene = SKScene(fileNamed: "ChainGameScene") as? ChainGameScene {
                    
                    scene.level = level
                    scene.gameOverDelegate = self
                    scene.scaleMode = .resizeFill
                    view.presentScene(scene)
                }
            }
        case "quit":
            if let view = self.view as! SKView? {
                if let scene = SKScene(fileNamed: "QuitGameScene") as? QuitGameScene {
                    
                    scene.level = level
                    scene.gameOverDelegate = self
                    scene.scaleMode = .resizeFill
                    view.presentScene(scene)
                }
            }
        default:
            break
        }
    }
    
    
    func setupBackImage() {
        self.backImageView.image = UIImage(named: "back")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        tap.numberOfTapsRequired = 1
        self.backImageView.isUserInteractionEnabled = true
        self.backImageView.addGestureRecognizer(tap)
    }
    
    func pushGameOverViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let gameOverViewController = storyboard.instantiateViewController(withIdentifier: "GameOverViewController") as? GameOverViewController else { return }
        gameOverViewController.levelsDelegate = self
        
        gameOverViewController.game = self.game
        gameOverViewController.won = self.won
        gameOverViewController.currentLevel = self.currentLevel
        self.present(gameOverViewController, animated: true)
    }
}

extension GameViewController: LevelsDelegate {
    func levelUp(_ currentLevel: Int) {
        let nextLevel = currentLevel + 1
        self.level = nextLevel
    }
    
    func popToLevelsViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
