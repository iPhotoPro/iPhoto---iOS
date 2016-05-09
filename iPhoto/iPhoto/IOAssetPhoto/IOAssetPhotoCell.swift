//
//  IOAssetPhotoCell.swift
//  iPhoto
//
//  Created by ngodacdu on 5/8/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class IOAssetPhotoCell: UICollectionViewCell {
    
    static let name = "IOAssetPhotoCell"
    static let identifier = "IOAssetPhotoCellIdentifier"
    
    let kShadowOffset = CGSize(width: 0, height: 2)
    let kShadowColor = UIColor.grayColor()
    let kShadowOpacity: Float = 0.8
    let kShadowRadius: CGFloat = 3
    let highlightedColor = UIColor(
        red: 26 / 255,
        green: 188 / 255,
        blue: 156 / 255,
        alpha: 1.0
    )
    
    var identifier: String?

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        addShadow(
            kShadowOffset,
            radius: kShadowRadius,
            opacity: kShadowOpacity,
            color: kShadowColor
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let _ = photoImageView {
            photoImageView.image = nil
        }
    }
    
    func updateState(isSelected: Bool) {
        if isSelected {
            backgroundColor = highlightedColor
        } else {
            backgroundColor = UIColor.whiteColor()
        }
    }
    
}

extension UIView {
    
    func addShadow(offset: CGSize, radius: CGFloat, opacity: Float, color: UIColor) {
        let shadowPath = UIBezierPath(rect: bounds)
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = color.CGColor
        layer.shadowOffset = CGSizeZero
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = shadowPath.CGPath
    }
    
}
