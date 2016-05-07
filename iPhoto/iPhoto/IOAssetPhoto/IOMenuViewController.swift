//
//  IOMenuViewController.swift
//  IOFetchAssetPhoto
//
//  Created by ngodacdu on 5/6/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import Photos

protocol IOMenuViewControllerDelegate: class {
    func tableViewDidSelected(indexPath: NSIndexPath, title: String?)
}

let kSectionKey = "SectionKeyMenu"
let kRowKey = "RowKeyMenu"

class IOMenuViewController: UIViewController {
    
    static let name = "IOMenuViewController"
    
    let kCellHeight: CGFloat = 66.0
    let targetSize = CGSize(width: 86.0, height: 86.0)
    private var photoSize = CGSizeZero
    let titles = ["All photo", "Smart album", "User collection"]
    lazy var dataSource: [PHFetchResult] = [PHFetchResult]()
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: IOMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDataSource()
        registerMenuCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func prepareDataSource() {
        let source = IOAssetPhoto()
        if let allPhoto = source.fetchAssetPhoto(.AllPhoto) {
            dataSource.append(allPhoto)
        }
        if let smartAlbum = source.fetchAssetPhoto(.SmartAlbum) {
            if smartAlbum.count > 0 {
                dataSource.append(smartAlbum)
            }
        }
        if let userCollection = source.fetchAssetPhoto(.UserCollection) {
            if userCollection.count > 0 {
                dataSource.append(userCollection)
            }
        }
    }

    @IBAction func dismissMenuViewController(sender: AnyObject) {
        modalTransitionStyle = .CrossDissolve
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension IOMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func registerMenuCell() {
        tableView.registerNib(
            UINib(nibName: IOMenuCell.Constant.name, bundle: nil),
            forCellReuseIdentifier: IOMenuCell.Constant.identifier
        )
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles[section]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kCellHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if section == IOAssetPhotoType.AllPhoto.hashValue {
            count = 1
        } else {
            count = dataSource[section].count
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(IOMenuCell.Constant.identifier, forIndexPath: indexPath) as! IOMenuCell
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let section = userDefault.valueForKey(kSectionKey)?.integerValue
        let row = userDefault.valueForKey(kRowKey)?.integerValue
        if section == nil || row == nil {
            if indexPath.section == 0 {
                cell.accessoryType = .Checkmark
            }
        } else {
            if indexPath.section == section && indexPath.row == row {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }
        var title: String? = String()
        if indexPath.section == IOAssetPhotoType.AllPhoto.hashValue {
            title = "All Photo"
        } else {
            if let collection = dataSource[indexPath.section][indexPath.row] as? PHCollection {
                title = collection.localizedTitle
            }
        }
        weak var weakSelf = self
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            var image = UIImage(named: "menu-default")
            if let fetchResult = weakSelf?.currentFetchResult(indexPath) {
                if fetchResult.count > 0 {
                    if let asset = fetchResult[0] as? PHAsset, strongSelf = weakSelf {
                        PHImageManager.defaultManager().requestImageForAsset(
                            asset,
                            targetSize: strongSelf.computeImageViewSize(),
                            contentMode: .AspectFill,
                            options: nil) { (result: UIImage?, info) in
                                image = result
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    cell.leftImageView.image = image
                    cell.title.text = title
                    cell.detail.text = "\(fetchResult.count)"
                })
            }
        }
        
        return cell
    }
    
    private func currentFetchResult(indexPath: NSIndexPath) -> PHFetchResult? {
        if indexPath.section == IOAssetPhotoType.AllPhoto.hashValue {
            return dataSource[IOAssetPhotoType.AllPhoto.hashValue]
        } else {
            if let collection = dataSource[indexPath.section][indexPath.row] as? PHAssetCollection {
                return PHAsset.fetchAssetsInAssetCollection(collection, options: nil)
            }
        }
        return nil
    }
    
    private func computeImageViewSize() -> CGSize {
        if photoSize == CGSizeZero {
            let scale = UIScreen.mainScreen().scale
            photoSize.width = scale * targetSize.width
            photoSize.height = scale * targetSize.height
        }
        return photoSize
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        weak var weakSelf = self
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! IOMenuCell
        self.delegate?.tableViewDidSelected(indexPath, title: cell.title.text)
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setValue(indexPath.section, forKey: kSectionKey)
        userDefault.setValue(indexPath.row, forKey: kRowKey)
        userDefault.synchronize()
        modalTransitionStyle = .CrossDissolve
        dismissViewControllerAnimated(true) {
            weakSelf?.dataSource.removeAll(keepCapacity: false)
        }
    }
    
}
