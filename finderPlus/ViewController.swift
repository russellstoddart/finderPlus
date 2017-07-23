//
//  ViewController.swift
//  finderPlus
//
//  Created by Russell Stoddart on 16/07/2017.
//  Copyright © 2017 Russell Stoddart. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate {

    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var contents: [String]?
    
    let pathManager = PathManager()
    
    @IBAction func didTapBack(_ sender: Any) {
        
        contents = pathManager.contentsOfParentDirectory()
        
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureCollectionView()
        
        contents = pathManager.contentsOfStartPath()
        
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return contents?.count ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        guard let collectionViewItem = collectionView.makeItem(withIdentifier: "CollectionViewItem", for: indexPath) as? CollectionViewItem else { fatalError() }
        
        collectionViewItem.textField?.stringValue = contents?[indexPath.item] ?? ""
        collectionViewItem.imageView?.image = NSImage(named: "folder")
        
        return collectionViewItem
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        guard let firstIndexPathItem = indexPaths.first?.item,
            let selectedFolder = contents?[firstIndexPathItem] else { fatalError() }
        
        contents = pathManager.contentsOfChildDirectory(named: selectedFolder)
        
        collectionView.reloadData()
    }
    
    private func configureCollectionView() {

        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.sectionInset = EdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        collectionView.collectionViewLayout = flowLayout
        
        view.wantsLayer = true
    }
}

