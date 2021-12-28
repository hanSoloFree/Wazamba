import UIKit

class GameOverViewController: BaseViewController {
    
    var won: Bool!
    var currentLevel: Int!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var buttonImageView: UIImageView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        configure(won: won)
    }
    
    @objc func tapped() {
        if won {
            guard let levelsViewController = navigationController?.viewControllers[1] else { return }
            let levelsOpened = UserDefaults.standard.integer(forKey: "LEVEL")
            if currentLevel == levelsOpened {
                let level = levelsOpened + 1
                UserDefaults.standard.set(level, forKey: "LEVEL")
            }
            self.navigationController?.popToViewController(levelsViewController, animated: true)
            
        } else {
        self.navigationController?.popViewController(animated: true)
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
