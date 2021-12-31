import UIKit

class GameOverViewController: BaseViewController {
    
    var won: Bool!
    var currentLevel: Int!
    var game: String!
    
    var levelUpDelegate: LevelUpDelegate?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var buttonImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        configure(won: won)
    }
    
    @objc func tapped() {
        if won {
            switch game {
            case "restore":
                let levelsOpened = UserDefaults.standard.integer(forKey: "restore levels")
                if currentLevel == levelsOpened {
                    let level = levelsOpened + 1
                    UserDefaults.standard.set(level, forKey: "restore levels")
                }
            case "chain":
                let levelsOpened = UserDefaults.standard.integer(forKey: "chain levels")
                if currentLevel == levelsOpened {
                    let level = levelsOpened + 1
                    UserDefaults.standard.set(level, forKey: "chain levels")
                }
            case "quit":
                let levelsOpened = UserDefaults.standard.integer(forKey: "quit levels")
                if currentLevel == levelsOpened {
                    let level = levelsOpened + 1
                    UserDefaults.standard.set(level, forKey: "quit levels")
                }
            default:
                break
            }
            levelUpDelegate?.levelUp()
            self.dismiss(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    func configure(won: Bool) {
        if won {
            backgroundImageView.image = UIImage(named: "wonBackground")
            buttonImageView.image = UIImage(named: "nextButton")
        } else {
            backgroundImageView.image = UIImage(named: "loseBackground")
            buttonImageView.image = UIImage(named: "replayButton")
        }
        setupGestures()
    }
    
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        self.buttonImageView.isUserInteractionEnabled = true
        self.buttonImageView.addGestureRecognizer(tap)
    }
}
