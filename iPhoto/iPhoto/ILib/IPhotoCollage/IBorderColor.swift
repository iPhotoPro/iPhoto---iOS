//
//  IBorderColor.swift
//  iPhoto
//
//  Created by ngodacdu on 5/20/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit

protocol IBorderColorDelegate: class {
    func didSelectedColor(color: IBorderColor, code: String)
}

class IBorderColor: UIView {

    class func loadFromNib() -> IBorderColor? {
        let objects = NSBundle.mainBundle().loadNibNamed("IBorderColor", owner: self, options: nil)
        return objects.first as? IBorderColor
    }
    
    var colors: [String] = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: IBorderColorDelegate?
    
    @IBAction func dismissBorderColorView(sender: AnyObject) {
        var currentFrame = frame
        currentFrame.origin.x = frame.width
        UIView.animateWithDuration(0.25, animations: {
            self.frame = currentFrame
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func showMoreColor(sender: AnyObject) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createColors()
        registerColorCell()
    }
    
    private func createColors() {
        colors.append("228B22")
        colors.append("008080")
        colors.append("CC8899")
        colors.append("DC143C")
        colors.append("C0C0C0")
        colors.append("007FFF")
        colors.append("FF7F50")
        colors.append("7FFFD4")
        colors.append("00FFFF")
        colors.append("808000")
        colors.append("FFD700")
        colors.append("FF77FF")
        colors.append("800000")
        colors.append("BFFF00")
    }

}

extension IBorderColor: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func registerColorCell() {
        collectionView.registerNib(
            UINib(nibName: IBorderColorCell.Constant.name, bundle: nil),
            forCellWithReuseIdentifier: IBorderColorCell.Constant.identifier
        )
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(IBorderColorCell.Constant.identifier, forIndexPath: indexPath) as! IBorderColorCell
        
        let colorHexa = colors[indexPath.row]
        cell.updateWithHexaColor(colorHexa as String)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? IBorderColorCell {
            cell.markView.hidden = false
            var offsetX: CGFloat = -1.0
            if cell.frame.origin.x < collectionView.contentOffset.x {
                offsetX = cell.frame.origin.x
                if indexPath.row > 0 {
                    offsetX = offsetX - cell.frame.width
                }
            } else if (cell.frame.origin.x + cell.frame.width) > (collectionView.contentOffset.x + collectionView.frame.width) {
                offsetX = cell.frame.origin.x + cell.frame.width - collectionView.frame.width
                if indexPath.row < (colors.count - 1) {
                    offsetX = offsetX + cell.frame.width
                }
            }
            UIView.animateWithDuration(0.25, animations: {
                if offsetX >= 0.0 {
                    self.collectionView.contentOffset.x = offsetX
                }
            })
        }
        delegate?.didSelectedColor(self, code: colors[indexPath.row])
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? IBorderColorCell {
            cell.markView.hidden = true
        }
    }
    
}
