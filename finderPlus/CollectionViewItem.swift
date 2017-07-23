//
//  CollectionViewItem.swift
//  finderPlus
//
//  Created by Russell Stoddart on 16/07/2017.
//  Copyright © 2017 Russell Stoddart. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
}
