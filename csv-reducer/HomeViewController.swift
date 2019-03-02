//
//  ViewController.swift
//  csv-reducer
//
//  Created by liuwill on 2019/3/2.
//  Copyright © 2019 liuwill. All rights reserved.
//

import Cocoa

class HomeViewController: NSViewController {

    @IBOutlet weak var fileButton: NSButton!
    @IBOutlet weak var filenameField: NSTextField!
    @IBOutlet weak var lineField: NSTextField!
    @IBOutlet weak var columnField: NSTextField!

    @IBOutlet weak var targetSizeField: NSTextField!
    @IBOutlet weak var targetColumnField: NSTextField!

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

    @IBAction func handleFileSplit(_ sender: Any) {
        if(self.filePath.count < 1) {
            let alert: NSAlert = NSAlert()
            alert.messageText = "未选择文件"
            alert.informativeText = "请先选择一个CSV文件"
            alert.alertStyle = NSAlert.Style.warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
            return
        }

        var columnCount:Int? = 0
        var fileSize:Int? = 2000
        
        if (self.targetColumnField.stringValue.count > 0) {
            columnCount = Int(self.targetColumnField.stringValue)
        }
        if (self.targetSizeField.stringValue.count > 0) {
            fileSize = Int(self.targetSizeField.stringValue)
        }

        let fileContent = try! String.init(contentsOfFile: self.filePath)
        let contentLines = fileContent.split(separator: "\n")

        let titleLine = contentLines[0]
        
        let singleFileContent = ""
        let tmpDir = NSTemporaryDirectory()
        let fileMap: [String: String]
        
        var count = 0
        for singleLine in contentLines {
            if count == 0{
                continue
            }
            let lineData = singleLine.split(separator: ",")

            
            count += 1
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
            if response == NSApplication.ModalResponse.OK {
//                let fileUrl = openPanel.url
                let selectedPath = openPanel.url!.path
                // do whatever you what with the file path
                
                self.filePath = selectedPath
                print("CSV SELECTED: " + selectedPath)
                
                self.filenameField.stringValue = selectedPath
//                let  readHandle = NSFileHandle.init(forReadingAtPath: selectedPath)
                let fileContent = try! String.init(contentsOfFile: selectedPath)
                let contentLines = fileContent.split(separator: "\n")
                self.lineField.stringValue = String(contentLines.count)
                self.columnField.stringValue = String(contentLines[0].split(separator: ",").count)
            }
            openPanel.close()
        }
    }
    
}

