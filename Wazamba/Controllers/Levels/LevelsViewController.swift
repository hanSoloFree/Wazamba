import UIKit

class LevelsViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgrroundImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var titleImageView: UIImageView!
    
    var game: String!
    var levelsCount: Int!
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let key = game + " levels"
        levelsCount = UserDefaults.standard.integer(forKey: key)
        images.removeAll()
        for number in 1...levelsCount {
            let name = "level" + String(describing: number)
            guard let levelImage = UIImage(named: name) else { return }
            
            self.images.append(levelImage)
        }
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(item: images.count - 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
    
    @objc func tapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func configure() {
        self.navigationController?.navigationBar.isHidden = true
        backgrroundImageView.image = UIImage(named: "levelsBackground")
        backImageView.image = UIImage(named: "back")
        let imageName = game + "Label"
        titleImageView.image = UIImage(named: imageName)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tap)
        
        let cellName = String(describing: LevelsCollectionViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)
    }
}


extension LevelsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: LevelsCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? LevelsCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.item  < levelsCount {
            cell.configure(with: images[indexPath.item])
        } else {
            guard let closedLevelImage = UIImage(named: "lockedLevel") else { return UICollectionViewCell() }
            cell.configure(with: closedLevelImage)
        }
        return cell
    }
}

extension LevelsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = 40.0
        return UIEdgeInsets(top: inset * 2, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < levelsCount {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let identifier = String(describing: GameViewController.self)
            guard let gameViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? GameViewController else { return }
            
            gameViewController.game = self.game
            
            gameViewController.level = indexPath.item + 1
            self.navigationController?.pushViewController(gameViewController, animated: true)
        } else {
            print("LOCKED")
        }
    }
}

extension LevelsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 128
        
        return CGSize(width: width, height: width)
    }
}
