import UIKit

class GameOverViewController: BaseViewController {
    
    var won: Bool!
    var currentLevel: Int!
    var game: String!
    
    var levelsDelegate: LevelsDelegate?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var levelsButtonImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        configure(won: won)
    }
    
    @objc func tappedLevels() {
        levelsDelegate?.popToLevelsViewController()
        self.dismiss(animated: true)
    }
    
    @objc func tappedPlay() {
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
            if currentLevel != 7 {
                levelsDelegate?.levelUp(currentLevel)
            } else {
                levelsDelegate?.popToLevelsViewController()
            }
            self.dismiss(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    func configure(won: Bool) {
        if won {
            backgroundImageView.image = UIImage(named: "wonBackground")
            playImageView.image = UIImage(named: "nextButton")
        } else {
            backgroundImageView.image = UIImage(named: "loseBackground")
            playImageView.image = UIImage(named: "replayButton")
        }
        levelsButtonImageView.image = UIImage(named: "levelsButton")
        setupGestures()
    }
    
    
    func setupGestures() {
        let tapPlay = UITapGestureRecognizer(target: self, action: #selector(tappedPlay))
        tapPlay.numberOfTapsRequired = 1
        self.playImageView.isUserInteractionEnabled = true
        self.playImageView.addGestureRecognizer(tapPlay)
        
        let tapLevels = UITapGestureRecognizer(target: self, action: #selector(tappedLevels))
        tapLevels.numberOfTapsRequired = 1
        self.levelsButtonImageView.isUserInteractionEnabled = true
        self.levelsButtonImageView.addGestureRecognizer(tapLevels)
    }
}
