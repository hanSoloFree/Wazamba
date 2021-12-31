import UIKit
import SpriteKit
import GameplayKit

class QuitGameViewController: BaseViewController, GameOverDelegate {
    
    var won: Bool?
    var level: Int!
    var currentLevel: Int?
    
    @IBOutlet weak var backImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackImage()
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
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
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

        gameOverViewController.game = "quit"
        gameOverViewController.won = self.won
        gameOverViewController.currentLevel = self.currentLevel
        self.present(gameOverViewController, animated: true)
    }
}

extension QuitGameViewController: LevelsDelegate {
    func levelUp() {
        self.level += 1
    }
    
    func popToLevelsViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
