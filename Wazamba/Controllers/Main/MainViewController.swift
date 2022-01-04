import UIKit

class MainViewController: BaseViewController {
    
    var musicIsOn: Bool = true {
        didSet {
            if musicIsOn {
                soundImageView.image = UIImage(named: "soundOn")
                player?.play()
            } else {
                soundImageView.image = UIImage(named: "soundOff")
                player?.stop()
            }
        }
    }

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playRestoreImageView: UIImageView!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var soundImageView: UIImageView!
    @IBOutlet weak var playChainGameImageView: UIImageView!
    @IBOutlet weak var playQuitImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        setupLevels()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
        showGamesInfo()
    }
    
    @objc func quitGameTapped() {
        setupLevelsViewController("quit")
    }
    
    @objc func chainGameTapped() {
        setupLevelsViewController("chain")
    }
    
    @objc func playTapped() {
        setupLevelsViewController("restore")
    }
    
    @objc func musicTapped() {
        self.musicIsOn = !self.musicIsOn
    }
    
    @objc func infoTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: PopoverViewController.self)
        guard let popOverViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? PopoverViewController else { return }
        self.present(popOverViewController, animated: true, completion: nil)
    }
    
    
    func showGamesInfo() {
        let shown = UserDefaults.standard.bool(forKey: "rules")
        if !shown {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let identifier = String(describing: PopoverViewController.self)
            guard let popOverViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? PopoverViewController else { return }
            self.present(popOverViewController, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "rules")
        }
    }
    
    func setupLevels() {
        if UserDefaults.standard.integer(forKey: "restore levels") < 1 {
            UserDefaults.standard.set(1, forKey: "restore levels")
        }
        
        if UserDefaults.standard.integer(forKey: "chain levels") < 1 {
            UserDefaults.standard.set(1, forKey: "chain levels")
        }
        
        if UserDefaults.standard.integer(forKey: "quit levels") < 1 {
            UserDefaults.standard.set(1, forKey: "quit levels")
        }
    }
    
    
    func setupGestures() {
        let playTap = UITapGestureRecognizer(target: self, action: #selector(playTapped))
        playTap.numberOfTapsRequired = 1
        self.playRestoreImageView.isUserInteractionEnabled = true
        self.playRestoreImageView.addGestureRecognizer(playTap)
        
        let chainGameTap = UITapGestureRecognizer(target: self, action: #selector(chainGameTapped))
        chainGameTap.numberOfTapsRequired = 1
        self.playChainGameImageView.isUserInteractionEnabled = true
        self.playChainGameImageView.addGestureRecognizer(chainGameTap)
        
        let quitGameTap = UITapGestureRecognizer(target: self, action: #selector(quitGameTapped))
        quitGameTap.numberOfTapsRequired = 1
        self.playQuitImageView.isUserInteractionEnabled = true
        self.playQuitImageView.addGestureRecognizer(quitGameTap)
        
        let musicTap = UITapGestureRecognizer(target: self, action: #selector(musicTapped))
        musicTap.numberOfTapsRequired = 1
        soundImageView.isUserInteractionEnabled = true
        soundImageView.addGestureRecognizer(musicTap)
        
        let infoTap = UITapGestureRecognizer(target: self, action: #selector(infoTapped))
        infoTap.numberOfTapsRequired = 1
        infoImageView.isUserInteractionEnabled = true
        infoImageView.addGestureRecognizer(infoTap)
    }
   
    
    func configure() {
        backgroundImageView.image = UIImage(named: "mainBackground")
        titleImageView.image = UIImage(named: "mainTitle")
        playRestoreImageView.image = UIImage(named: "restoreButton")
        playChainGameImageView.image = UIImage(named: "chainButton")
        playQuitImageView.image = UIImage(named: "quitButton")
        infoImageView.image = UIImage(named: "info")
        guard let player = player else { return }
        if player.isPlaying {
            soundImageView.image = UIImage(named: "soundOn")
        } else {
            soundImageView.image = UIImage(named: "soundOff")
        }
    }
    
    func setupLevelsViewController(_ game: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: LevelsViewController.self)
        guard let levelsViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? LevelsViewController else { return }
        levelsViewController.game = game
        
        self.navigationController?.pushViewController(levelsViewController, animated: true)
    }
}


