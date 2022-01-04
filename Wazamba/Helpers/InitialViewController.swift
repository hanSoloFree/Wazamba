import UIKit
import Firebase
import AppTrackingTransparency

class InitialViewController: BaseViewController {


    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: "loader") {
            backgroundImageView.image = image
        }
        view.addSubview(backgroundImageView)
        backgroundImageView.fillSuperView()
        view.addSubview(indicator)
        indicator.ancherToSuperviewsCenter()

        checkWithChecker()
    }

    func checkWithChecker() {

        Checker.shared.checkEveryting { (url) in
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                if let url = url {
                    print("TUTORIAL: \(url)")
                    self.openHelp(with: url)
                } else {
                    print("NATIVE NATIVE NATIVE")
                    self.openGame()
                }
            }
            
        }
    }

    func openHelp(with url: URL) {
        indicator.stopAnimating()

        let helpVC = HelpViewController()
        helpVC.modalPresentationStyle = .fullScreen
        helpVC.url = url
        self.present(helpVC, animated: false, completion: nil)
    }


    func openGame() {
        indicator.stopAnimating()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "menu")
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }

}

extension UIView {
    func fillSuperView() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        ])
    }

    func ancherToSuperviewsCenter() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
    }
}
