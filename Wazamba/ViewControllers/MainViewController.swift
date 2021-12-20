import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!



    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.integer(forKey: "LEVEL") < 1 {
            UserDefaults.standard.set(1, forKey: "LEVEL")
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
        
        self.navigationController?.pushViewController(levelsViewController, animated: true)
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {

        guard let popOverViewController = storyboard?.instantiateViewController(withIdentifier: "PopoverViewController") as? PopoverViewController else { return }
        self.present(popOverViewController, animated: true, completion: nil)
        
    }
    
}


