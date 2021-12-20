import UIKit

class LevelsViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgrroundImageView: UIImageView!
    
    var levelsCount: Int!
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        backgrroundImageView.image = UIImage(named: "background")
        let cellName = String(describing: LevelsCollectionViewCell.self)
        collectionView.register(UINib(nibName: cellName, bundle: nil),
                                forCellWithReuseIdentifier: cellName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        levelsCount = UserDefaults.standard.integer(forKey: "LEVEL")
        images.removeAll()
        for number in 1...levelsCount {
            let name = "level" + String(describing: number)
            guard let levelImage = UIImage(named: name) else { return }
            
            self.images.append(levelImage)
        }
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let indexPath = IndexPath(item: images.count - 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
    }
}


extension LevelsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: LevelsCollectionViewCell.self)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? LevelsCollectionViewCell else { return UICollectionViewCell() }
        
        
        cell.configure(with: images[indexPath.item])
        return cell
    }
}

extension LevelsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 64, left: 64, bottom: 64, right: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: GameViewController.self)
        guard let gameViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? GameViewController else { return }
        
        gameViewController.level = indexPath.item + 1
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
}

extension LevelsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 128
        
        return CGSize(width: width, height: width)
    }
}
