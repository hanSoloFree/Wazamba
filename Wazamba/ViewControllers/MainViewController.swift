import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    var levelsCount: Int = 7
    var images: [UIImage] = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        for number in 1...levelsCount {
            let name = "level" + String(describing: number)
            guard let levelImage = UIImage(named: name) else { return }
            self.images.append(levelImage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    func configure() {
        backgroundImageView.image = UIImage(named: "background")
        startButton.layer.cornerRadius = 15
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let levelsViewController = storyboard.instantiateViewController(withIdentifier: "LevelsViewController") as? LevelsViewController else { return }
        levelsViewController.levelsCount = self.levelsCount
        levelsViewController.images = self.images
        
        self.navigationController?.pushViewController(levelsViewController, animated: true)
    }
}
