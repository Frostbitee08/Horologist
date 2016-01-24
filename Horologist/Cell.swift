//
//  Cell.swift
//  Horologist
//
//  Created by Rocco Del Priore on 1/24/16.
//  Copyright © 2016 Rocco Del Priore. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Photos

class Cell: UICollectionViewCell {
    var imageView: UIImageView?
    var selectedView: UIView?
    var asset: PHAsset?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Variables
        let selectedSize = 30
        let selectedOffset = 4
        self.imageView = UIImageView(frame: CGRectZero)
        self.selectedView = UIView(frame: CGRectZero)
        
        //Properties
        self.selectedView?.backgroundColor = UIColor.redColor()
        
        //Add Subviews
        self.contentView.addSubview(self.imageView!)
        self.contentView.addSubview(self.selectedView!)
        
        //Set Constraints
        self.imageView?.snp_makeConstraints(closure: { (make) -> Void in
            make.center.equalTo(self.contentView)
            make.size.equalTo(self.contentView)
        })
        self.selectedView?.snp_makeConstraints(closure: { (make) -> Void in
            make.right.equalTo(self.contentView).offset(-selectedOffset)
            make.bottom.equalTo(self.contentView).offset(-selectedOffset)
            make.size.equalTo(selectedSize)
        })
    }
    
    //override func
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectedView?.layer.cornerRadius = self.selectedView!.frame.size.width/2
        self.selectedView?.layer.masksToBounds = false
        
        self.imageView?.layer.cornerRadius = 7
        self.imageView?.layer.masksToBounds = false
    }
    
    func setSelectedState(selection: Bool) {
        
        self.selectedView?.hidden = !selection;
        self.selected = selection
    }
    
    func setImageBasedOnAsset(newAsset: PHAsset) {
        if (asset != newAsset) {
            asset = newAsset
            PHImageManager.defaultManager().requestImageForAsset(asset!, targetSize: CGSizeMake(frame.width, frame.height), contentMode: PHImageContentMode.AspectFill, options: nil) { (image:UIImage?, info) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageView?.image = image
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}