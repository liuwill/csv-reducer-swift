//
//  ViewController.swift
//  csv-reducer
//
//  Created by videopls on 2019/3/2.
//  Copyright © 2019 liuwill. All rights reserved.
//

import Cocoa

class HomeViewController: NSViewController {

    @IBOutlet weak var fileButton: NSButton!
    @IBOutlet weak var filenameField: NSTextField!
    @IBOutlet weak var lineField: NSTextField!
    
    var filePath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func chooseCsvFile(_ sender: NSButton) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["csv"]
        openPanel.title = "选择一个CSV文件"
        openPanel.beginSheetModal(for:self.view.window!) { (response) in
            if response.rawValue == NSFileHandlingPanelOKButton {
                let fileUrl = openPanel.url
                let selectedPath = openPanel.url!.path
                // do whatever you what with the file path
                
                self.filePath = selectedPath
                print("CSV SELECTED: " + selectedPath)
                
                self.filenameField.stringValue = selectedPath
//                let  readHandle = NSFileHandle.init(forReadingAtPath: selectedPath)
                let fileContent = try! String.init(contentsOfFile: selectedPath)
                let contentLines = fileContent.split(separator: "\n")
                self.lineField.stringValue = String(contentLines.count)
            }
            openPanel.close()
        }
    }
    
}

