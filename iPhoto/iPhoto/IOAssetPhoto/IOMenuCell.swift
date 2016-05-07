//
//  IOMenuCell.swift
//  IOFetchAssetPhoto
//
//  Created by ngodacdu on 5/6/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

class IOMenuCell: UITableViewCell {
    
    struct Constant {
        static let name = "IOMenuCell"
        static let identifier = "IOMenuCellIdentifier"
    }

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leftImageView.image = nil
        accessoryType = .None
    }
    
}
