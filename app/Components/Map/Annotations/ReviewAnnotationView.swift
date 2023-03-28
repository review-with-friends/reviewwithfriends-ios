//
//  ReviewAnnotationView.swift
//  app
//
//  Created by Colton Lathrop on 2/13/23.
//

import Foundation
import MapKit

class ReviewAnnotationView: MKAnnotationView {
    var photo: String?
    var category: String?
    
    override var isHidden: Bool {
        didSet {
            if isHidden {
                for subview in subviews {
                    subview.removeFromSuperview()
                }
            }
        }
    }

    let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.layer.cornerRadius = 25.0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        addSubview(imageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        if let photoURL = photo {
            let url = URL(string: photoURL)
            imageView.sd_setImage(with: url)
        } else {
            imageView.image = nil
        }
        
        if let category = self.category {
            if let systemImage = MKPointOfInterestCategory.getCategory(category: category)?.getSystemImageString() {
                let iconBg = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                iconBg.layer.cornerRadius = 10
                iconBg.clipsToBounds = true
                iconBg.backgroundColor = MKPointOfInterestCategory.getCategoryColor(category: category)
                iconBg.center = CGPoint(x: 42, y: 8)
                
                let icon = UIImageView(image: UIImage(systemName: systemImage))
                icon.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
                icon.contentMode = .scaleAspectFit
                icon.tintColor = .black
                icon.center = iconBg.convert(iconBg.center, from: icon);
                
                iconBg.addSubview(icon)
                addSubview(iconBg)
            }
        }
    }
}
