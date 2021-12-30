import UIKit

class QuitLevelsViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgrroundImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var levelsCount: Int!
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        backgrroundImageView.image = UIImage(named: "levelsBackground")
        backImageView.image = UIImage(named: "back")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(tap)
        
        let cellName = String(describing: LevelsCollectionViewCell.self)
        let cellNib = UINib(nibName: cellName, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        levelsCount = UserDefaults.standard.integer(forKey: "quit levels")
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
    
    @objc func tapped() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}


extension QuitLevelsViewController: UICollectionViewDataSource {
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

extension QuitLevelsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = 40.0
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: QuitGameViewController.self)
        guard let quitGameViewController = storyboard.instantiateViewController(withIdentifier: identifier) as? QuitGameViewController else { return }
        quitGameViewController.level = indexPath.item + 1
        self.navigationController?.pushViewController(quitGameViewController, animated: true)
    }
}

extension QuitLevelsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width - 128
        
        return CGSize(width: width, height: width)
    }
}
