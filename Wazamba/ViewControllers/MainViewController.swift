import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func configure() {
        backgroundImageView.image = UIImage(named: "background")
        startButton.layer.cornerRadius = 15
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let levelsViewController = storyboard.instantiateViewController(withIdentifier: "LevelsViewController") as? LevelsViewController else { return }
        self.navigationController?.pushViewController(levelsViewController, animated: true)
    }
}
