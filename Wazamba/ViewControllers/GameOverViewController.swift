import UIKit

class GameOverViewController: UIViewController {
    
    var won: Bool!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var winLoseImageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        configure(won: won)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configure(won: Bool) {
        backgroundImageView.image = UIImage(named: "background")
        button.layer.cornerRadius = 15
        var buttonText = ""
        var imageName = ""
        if won {
            buttonText = "NEXT!"
            imageName = "won"
        } else {
            buttonText = "TRY AGAIN"
            imageName = "lose"
        }
        self.button.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 32)
        self.button.titleLabel?.text = buttonText
        self.winLoseImageView.image = UIImage(named: imageName)
    }
}
