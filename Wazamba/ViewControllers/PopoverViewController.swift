import UIKit

class PopoverViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoLabel.text = "Game info!\n\n You have to remember the positions of blocks and restore before countdown ends!\n\nWith each new level it gets harder and harder."
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundView.layer.cornerRadius = 20
    }
    
    @objc func tap() {
        self.dismiss(animated: true, completion: nil)
    }
 
}
