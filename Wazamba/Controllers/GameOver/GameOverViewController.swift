import UIKit

class GameOverViewController: BaseViewController {
    
    var won: Bool!
    var currentLevel: Int!
    var game: String!
    
    var levelsDelegate: LevelsDelegate?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var levelsButtonImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure(won: won)
    }
    
    @objc func tappedLevels() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        levelsDelegate?.popToLevelsViewController()
        self.dismiss(animated: true) {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    @objc func tappedPlay() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        if won {
            levelUp(game)
            if currentLevel != 7 {
                levelsDelegate?.levelUp(currentLevel)
            }
        }
        self.dismiss(animated: true) {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func levelUp(_ game: String) {
        let key = game + " levels"
        let levelsOpened = UserDefaults.standard.integer(forKey: key)
        if currentLevel == levelsOpened {
            let level = levelsOpened + 1
            UserDefaults.standard.set(level, forKey: key)
        }
    }
    
    func configure(won: Bool) {
        self.activityIndicator.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        if won {
            backgroundImageView.image = UIImage(named: "wonBackground")
            playImageView.image = UIImage(named: "nextButton")
        } else {
            backgroundImageView.image = UIImage(named: "loseBackground")
            playImageView.image = UIImage(named: "replayButton")
        }
        
        if currentLevel == 7 {
            self.playImageView.isHidden = true
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
