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
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var soundImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        let playTap = UITapGestureRecognizer(target: self, action: #selector(playTapped))
        playTap.numberOfTapsRequired = 1
        self.playImageView.isUserInteractionEnabled = true
        self.playImageView.addGestureRecognizer(playTap)
        
        let musicTap = UITapGestureRecognizer(target: self, action: #selector(musicTapped))
        musicTap.numberOfTapsRequired = 1
        soundImageView.isUserInteractionEnabled = true
        soundImageView.addGestureRecognizer(musicTap)
        
        let infoTap = UITapGestureRecognizer(target: self, action: #selector(infoTapped))
        infoTap.numberOfTapsRequired = 1
        infoImageView.isUserInteractionEnabled = true
        infoImageView.addGestureRecognizer(infoTap)
        
        if UserDefaults.standard.integer(forKey: "LEVEL") < 1 {
            UserDefaults.standard.set(1, forKey: "LEVEL")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
   
    
    func configure() {
        backgroundImageView.image = UIImage(named: "mainBackground")
        titleImageView.image = UIImage(named: "mainTitle")
        playImageView.image = UIImage(named: "playButton")
        infoImageView.image = UIImage(named: "info")
        soundImageView.image = UIImage(named: "soundOn")
        playSound()
    }
    
    @objc func playTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: LevelsViewController.self)
        guard let levelsViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? LevelsViewController else { return }
        
        self.navigationController?.pushViewController(levelsViewController, animated: true)
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
}


