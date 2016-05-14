//
//  IPActionAdjustmentCell.swift
//  iPhoto
//
//  Created by ngodacdu on 5/12/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class IPActionAdjustmentCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var functionName: UILabel!
    
    struct Constant {
        static let name = "IPActionAdjustmentCell"
        static let identifier = "IPActionAdjustmentCellIdentifier"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "edit-default")
        functionName.text = nil
    }
    
    func update(imageName: String?, name: String) {
        if let imageName = imageName where !imageName.isEmpty {
            imageView.image = UIImage(named: imageName)
        }
        functionName.text = name
    }

}
