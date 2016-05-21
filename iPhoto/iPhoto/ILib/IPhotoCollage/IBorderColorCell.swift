//
//  IBorderColorCell.swift
//  iPhoto
//
//  Created by ngodacdu on 5/20/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class IBorderColorCell: UICollectionViewCell {
    
    struct Constant {
        static let name = "IBorderColorCell"
        static let identifier = "IBorderColorCellIdentifier"
    }

    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var colorHexa: String = "FFFFFF" {
        didSet {
            imageView.backgroundColor = UIColor(hexa: colorHexa)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateImage(imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
    
    func updateWithHexaColor(hexa: String) {
        colorHexa = hexa
        imageView.image = nil
    }
    
    override func prepareForReuse() {
        markView.hidden = true
    }

}

extension UIColor {
    
    convenience init(hexa: String) {
        let scanner = NSScanner(string: hexa)
        var color: UInt32 = 0
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask) / 255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask) / 255.0)
        let b = CGFloat(Float(Int(color) & mask) / 255.0)
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
}
