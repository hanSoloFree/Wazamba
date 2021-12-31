import UIKit

class PopoverViewController: BaseViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoLabel.text =
            "Games info!\n\n1. Restore game. You have to remember the positions of blocks and restore before countdown ends!\n\n2. Chain game. Each block blinks in a random sequence. Your task is to repeat the chain.\n\n3. Quit game. Blocks shakes, but only one don't. Find it!."
        self.infoLabel.adjustsFontSizeToFitWidth = true
        self.infoLabel.minimumScaleFactor = 0.8
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundView.addSubview(blurEffect)
        self.backgroundView.layer.cornerRadius = 20

        self.blurEffect.layer.masksToBounds = true
        self.blurEffect.layer.cornerRadius = 20
    }
    
    @objc func tap() {
        self.dismiss(animated: true, completion: nil)
    }
}
