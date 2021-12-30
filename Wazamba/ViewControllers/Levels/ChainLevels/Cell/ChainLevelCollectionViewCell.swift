import UIKit

class ChainLevelCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configure(with image: UIImage) {
        self.backgroundImageView.image = image
    }
}
