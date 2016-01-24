//
//  ViewController.swift
//  Horologist
//
//  Created by Rocco Del Priore on 1/24/16.
//  Copyright © 2016 Rocco Del Priore. All rights reserved.
//

import SnapKit
import UIKit

let reuseIdentifier = "reuseIdentifier"

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ModelDelegate {
    var layout: UICollectionViewFlowLayout?
    var collectionView: UICollectionView?
    var refresh: UIRefreshControl?
    var button: UIButton?
    var model: Model?
    
    //MARK: Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize Variables
        self.view.backgroundColor = UIColor.whiteColor()
        model = Model()
        layout = UICollectionViewFlowLayout()
        button = UIButton(frame: CGRect.zero)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout!)
        refresh = UIRefreshControl()
        
        //Add Attributes
        let width = (self.view.frame.size.width-144)/3;
        let height = width*1.25
        let spacing = 26.0 as CGFloat
        model?.delegate = self
        layout?.minimumLineSpacing = spacing
        layout?.minimumInteritemSpacing = spacing
        layout?.itemSize = CGSize(width: width, height: height)
        collectionView?.registerClass(Cell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.clearColor()
        collectionView?.allowsMultipleSelection = true
        collectionView?.alwaysBounceVertical = true
        collectionView?.dataSource = self
        collectionView?.delegate = self
        button?.backgroundColor = UIColor.redColor()
        button?.addTarget(model, action:"removeSelectedAssets", forControlEvents: UIControlEvents.TouchUpInside)
        refresh?.addTarget(model, action:"fetchAssets", forControlEvents: UIControlEvents.ValueChanged)
        
        //Add Subviews
        collectionView?.addSubview(refresh!)
        self.view.addSubview(collectionView!)
        self.view.addSubview(button!)
        
        //Add Constraints
        let buttonSize = 50
        collectionView?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.view).offset(UIApplication.sharedApplication().statusBarFrame.size.height)
            make.left.equalTo(self.view).offset(36)
            make.right.equalTo(self.view).offset(-36)
            make.bottom.equalTo(self.view).offset(-20-buttonSize)
        })
        button?.snp_makeConstraints(closure: { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.size.equalTo(buttonSize)
            make.bottom.equalTo(self.view).offset(-10)
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        button?.layer.cornerRadius = button!.frame.size.width/2
        button?.layer.masksToBounds = false
    }
    
    //MARK: Model Delegate
    func reloadData() {
        self.refresh?.endRefreshing()
        self.collectionView?.reloadData()
    }
    
    //MARK: CollectionVieW Datasource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model!.numberOfItemsInSection()
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! Cell
        cell.setImageBasedOnAsset(model!.assetForIndexPath(indexPath))
        if model!.selectedObjectAtIndexPath(indexPath) {
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition.None)
        }
        else {
            cell.setSelectedState(model!.selectedObjectAtIndexPath(indexPath))
        }
        return cell
    }
    
    //MARK: CollectionView Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! Cell
        model?.didSelectItemAtPath(true, indexPath: indexPath)
        cell.setSelectedState(true)
    }
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! Cell
        model?.didSelectItemAtPath(false, indexPath: indexPath)
        cell.setSelectedState(false)
    }
}
