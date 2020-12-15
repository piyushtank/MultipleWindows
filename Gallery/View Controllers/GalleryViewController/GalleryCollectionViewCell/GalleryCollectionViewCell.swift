/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A basic collection view cell that displays an image.
*/

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var imageView: UIImageView!

    var image: UIImage! {
        didSet {
            imageView.image = image
        }
    }

}
