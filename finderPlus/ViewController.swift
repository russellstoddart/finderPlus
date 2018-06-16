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
    @IBOutlet weak var commandTableView: NSTableView!
    @IBOutlet weak var commandField: NSTextField!
    @IBAction func didEnterCommand(_ sender: NSTextField) {
        previousCommands.append("russellstoddart$ \(sender.stringValue)")
        let command = Command(phrase: sender.stringValue)
        print(command.listOfArguments())
        let (output, status) = shell(launchPath: "/usr/bin/env", arguments: command.listOfArguments())
        if let output = output {
            print(output, status)
            previousCommands.append(contentsOf: output.components(separatedBy: CharacterSet.newlines))
        }
        commandTableView.reloadData()
        commandTableView.scrollToEndOfDocument(nil)
    }

    var contents: [String]?
    
    let pathManager = PathManager()
    
    @IBAction func didTapBack(_ sender: Any) {
        
        contents = pathManager.contentsOfParentDirectory()
        
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureCommandField()

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
        flowLayout.itemSize = NSSize(width: 80.0, height: 80.0)
        flowLayout.sectionInset = EdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        collectionView.collectionViewLayout = flowLayout
        
        view.wantsLayer = true
    }

    private func configureCommandField() {
        commandField.focusRingType = .none
    }

//    @discardableResult
//    private func shell(_ args: String...) -> Int32 {
//        let task = Process()
//        task.launchPath = "/usr/bin/env"
//        task.arguments = args
//        task.launch()
//        task.waitUntilExit()
//        return task.terminationStatus
//    }

    var previousTasks: [Process] = []
    var previousTaskDirectoryURL: URL?
    private func shell(launchPath: String, arguments: [String] = []) -> (output: String?, status: Int32) {
        let task = Process()
        previousTasks.append(task)
        task.launchPath = launchPath
        task.arguments = arguments//["xcodebuild", "test", "-scheme", "JLAPI", "-configuration", "Debug", "-destination", "platform=iOS Simulator,OS=11.3,name=iPhone 6s", "-workspace", "JLAPI.xcworkspace"]//arguments
//        if let directoryURL = previousTaskDirectoryURL {
//            task.currentDirectoryURL = directoryURL
//        }

        let pipe = Pipe()
        task.standardInput = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        task.waitUntilExit()
        previousTaskDirectoryURL = task.currentDirectoryURL
        print(task.currentDirectoryURL?.absoluteString)
        return (output: output, status: task.terminationStatus)
    }

    var previousCommands: [String] = []
}

extension ViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        return previousCommands.count
    }
}

extension ViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let command = previousCommands[row]

        let text: String = command
        let cellIdentifier: String = "commandCell"

        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}
