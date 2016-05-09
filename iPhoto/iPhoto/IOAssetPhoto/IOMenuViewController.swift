//
//  IOMenuViewController.swift
//  iPhoto
//
//  Created by ngodacdu on 5/8/16.
//  Copyright © 2016 ngodacdu. All rights reserved.
//

import UIKit
import DLPhotoPicker

protocol IOMenuViewControllerDelegate: class {
    func didSelectedRow(collection: DLPhotoCollection)
}

class IOMenuViewController: DLPhotoTableViewController {
    
    weak var delegate: IOMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerMenuCell()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareNavigationItem()
    }
    

    private func prepareNavigationItem() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationController?.navigationBar.topItem?.title = "Collection"
        let dismissBarButton = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .Plain,
            target: self,
            action: #selector(IOMenuViewController.didTouchUpInsideBackButton(_:))
        )
        navigationItem.leftBarButtonItem = dismissBarButton
        tableView.separatorStyle = .SingleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
    }
    
    func didTouchUpInsideBackButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

extension IOMenuViewController {
    
    private func registerMenuCell() {
        tableView.registerClass(
            IOMenuCell.self,
            forCellReuseIdentifier: IOMenuCell.identifier
        )
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(IOMenuCell.identifier, forIndexPath: indexPath) as! IOMenuCell
        if let _ = tableView.indexPathsForVisibleRows?.contains(indexPath) {
            cell.selectionStyle = .None
            if let collection = self.photoCollections[indexPath.row] as? DLPhotoCollection {
                cell.bind(collection, count: collection.count)
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let collection = photoCollections[indexPath.row] as? DLPhotoCollection {
            delegate?.didSelectedRow(collection)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
