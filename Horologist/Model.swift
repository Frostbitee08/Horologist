//
//  Model.swift
//  Horologist
//
//  Created by Rocco Del Priore on 1/24/16.
//  Copyright © 2016 Rocco Del Priore. All rights reserved.
//

import Foundation
import Photos

protocol ModelDelegate {
    func reloadData()
}

class Model : NSObject {
    var delegate : ModelDelegate! = nil
    var assets : NSMutableArray?
    var selected: NSMutableArray?
    
    //MARK: Intiializers
    override init() {
        super.init()
        assets = NSMutableArray()
        selected = NSMutableArray()
        self.fetchAssets()
    }
    
    //MARK: Actions
    func fetchAssets() {
        let moments = PHAssetCollection.fetchMomentsWithOptions(nil)
        if (moments.count > 0) {
            for carrot: Int in 0...moments.count-1 {
                let moment: AnyObject! = moments.objectAtIndex(carrot)
                let assets = PHAsset.fetchAssetsInAssetCollection(moment! as! PHAssetCollection, options: nil)
                if (assets.count > 0) {
                    for stick : Int in 0...assets.count-1 {
                        let asset : PHAsset = assets.objectAtIndex(stick) as! PHAsset
                        if asset.pixelWidth == 216 && asset.pixelHeight == 290 {
                            if !self.assets!.containsObject(asset) {
                                self.assets!.addObject(asset)
                                self.selected!.addObject(asset)
                            }
                        }
                        else if asset.pixelWidth == 312 && asset.pixelHeight == 390 {
                            if !self.assets!.containsObject(asset) {
                                self.assets!.addObject(asset)
                                self.selected!.addObject(asset)
                            }
                        }
                    }
                }
            }
        }
        if self.delegate != nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(dispatch_get_main_queue()) {
                    self.delegate.reloadData()
                }
            }
        }
    }
    
    func removeSelectedAssets() {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            PHAssetChangeRequest.deleteAssets(self.selected!)
            }, completionHandler: { (complete: Bool, error: NSError?) -> Void in
                if complete {
                    self.assets?.removeObjectsInArray(self.selected! as [AnyObject])
                    self.selected?.removeAllObjects()
                    self.fetchAssets()
                }
        })
    }
    
    func selectedObjectAtIndexPath(indexPath : NSIndexPath) -> Bool {
        if self.selected!.containsObject(self.assets!.objectAtIndex(indexPath.row)) {
            return true
        }
        return false
    }
    
    //MARK: CollectionView Datasource
    func numberOfItemsInSection() -> Int {
        if (assets != nil) {
            return assets!.count
        }
        return 0
    }
    
    func assetForIndexPath(indexPath: NSIndexPath) -> PHAsset {
        return self.assets!.objectAtIndex(indexPath.row) as! PHAsset
    }
    
    //MARK: CollectionView Delegate
    func didSelectItemAtPath(selected: Bool, indexPath: NSIndexPath) {
        if (selected) {
            if (!self.selected!.containsObject(self.assets!.objectAtIndex(indexPath.row))) {
                self.selected!.addObject(self.assets!.objectAtIndex(indexPath.row))
            }
        }
        else {
            self.selected!.removeObject(self.assets!.objectAtIndex(indexPath.row))
        }
    }
}