//
//  IOAssetPhotoCell.swift
//  IOFetchAssetPhoto
//
//  Created by ngodacdu on 5/5/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class IOAssetPhotoCell: UICollectionViewCell {
    
    let kImageViewPadding: CGFloat = 4
    let kShadowOffset = CGSize(width: 0, height: 2)
    let kShadowColor = UIColor.grayColor()
    let kShadowOpacity: Float = 0.8
    let kShadowRadius: CGFloat = 3
    let kSizeImageSlected: CGSize = CGSize(width: 15.0, height: 15.0)
    
    struct Constant {
        static let identifier = "IOPhotoCellIdentifier"
    }
    
    var representedAssetIdentifier: String?
    private var imageView: UIImageView!
    private var selectedImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        prepareImageView(frame)
    }
    
    private func prepareImageView(frame: CGRect) {
        if imageView == nil {
            var f = frame
            f.size.width = f.width - kImageViewPadding
            f.size.height = f.height - kImageViewPadding
            imageView = UIImageView(frame: f)
            imageView.center = contentView.center
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            contentView.addSubview(imageView)
        }
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateImage(image: UIImage?) {
        imageView.image = image
    }
    
    func updateState(isSelected: Bool) {
        if selectedImageView == nil {
            let image = UIImage(named: "photo-selected")
            selectedImageView = UIImageView(image: image)
            let centerX: CGFloat = frame.width - kSizeImageSlected.width / 2
            let centerY: CGFloat = frame.height - kSizeImageSlected.height / 2
            selectedImageView.center = CGPoint(x: centerX, y: centerY)
            addSubview(selectedImageView)
        }
        if isSelected {
            selectedImageView.hidden = false
            backgroundColor = UIColor(red: 26 / 255, green: 188 / 255, blue: 156 / 255, alpha: 1.0)
        } else {
            selectedImageView.hidden = true
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
