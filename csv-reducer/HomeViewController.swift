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
    @IBOutlet weak var finishColumnField: NSTextField!

    @IBOutlet weak var targetSizeField: NSTextField!
    @IBOutlet weak var targetColumnField: NSTextField!
    @IBOutlet weak var targetIdField: NSTextField!

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
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = false
        openPanel.title = "选择保存目录"
        openPanel.beginSheetModal(for:self.view.window!) { (response) in
            openPanel.close()
            if response == NSApplication.ModalResponse.OK {
                self.writeDownTargetFile(fileUrl: openPanel.url)
            }
        }
    }

    func alertMessage(title: String, message: String) {
        let alert: NSAlert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    func writeDownTargetFile (fileUrl: URL?) {
        if(self.filePath.count < 1) {
            self.alertMessage(title: "未选择文件", message: "请先选择一个CSV文件")
            return
        }

        let filenameData = self.filePath.split(separator: "/")
        let sourcePath = filenameData[0...filenameData.count - 2].joined(separator: "/")
        let fileName = filenameData[filenameData.count - 1]
        let fileSplitArr = fileName.split(separator: ".")
        let pureFileName = fileSplitArr[0]

        var startId: Int32 = 10000
        var columnCount: Int32 = 2
        var fileSize: Int32 = 5000

        if (self.targetColumnField.stringValue.count > 0) {
            columnCount = self.targetColumnField.intValue
        }
        if (self.targetSizeField.stringValue.count > 0) {
            fileSize = self.targetSizeField.intValue
        }
        
        // 读取并开始处理文件
        var titleStr = ""

        var count:Int32 = 0
        self.finishColumnField.intValue = 0
        if let aStreamReader = StreamReader(path: self.filePath) {
            defer {
                aStreamReader.close()
            }

            while let singleLine = aStreamReader.nextLine() {
                if count == 0 {
                    count += 1
                    titleStr = singleLine
                    let titleLine = titleStr.split(separator: ",")
                    if (titleLine.count < columnCount - 1) {
                        self.alertMessage(title: "文件格式不正确", message: "文件没有指定索引列")
                        return
                    }
                    continue
                }
                
                count += 1
                let lineData = singleLine.split(separator: ",")
                let idVal = lineData[1]
                let idIntVal = Int32(idVal)
                let fileNo = (idIntVal ?? 0 - startId) / fileSize
                let lineFileName = fileUrl!.path + "/" + pureFileName + "-" + String(fileNo) + ".csv"
                
                //            print(lineFileName)
                let fileURL = URL(fileURLWithPath: lineFileName)
                let fileManager = FileManager.default
                if !fileManager.fileExists(atPath: lineFileName) {
                    let writeTitle = titleStr + "\n"
                    let createSuccess = fileManager.createFile(atPath: lineFileName,contents:writeTitle.data(using: .utf8),attributes:nil)
                    print("FILE Create: : \(createSuccess): " + lineFileName)
                }
                
                let writeLine = singleLine + "\n"
                do {
                    let fileHandle = try FileHandle(forWritingTo: fileURL)
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(writeLine.data(using: .utf8)!)
                    fileHandle.closeFile()
                } catch {
                    print("Error writing to file \(error)")
                }

                self.finishColumnField.stringValue = String(count)
            }
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
            openPanel.close()

            if response == NSApplication.ModalResponse.OK {
                let fileUrl = openPanel.url
                let selectedPath = openPanel.url!.path
                // do whatever you what with the file path
                
                self.filePath = selectedPath
                print("CSV SELECTED: " + selectedPath)

                if let aStreamReader = StreamReader(path: selectedPath) {
                    defer {
                        aStreamReader.close()
                    }
                    
                    var count = 0
                    var firstLine = ""
                    while let line = aStreamReader.nextLine() {
                        if (count == 0) {
                            firstLine = line
                        }
                        count += 1
                    }
                    self.lineField.stringValue = String(count)
                    self.columnField.stringValue = String(firstLine.split(separator: ",").count)
                }
                self.finishColumnField.intValue = 0
                self.filenameField.stringValue = selectedPath
            }
        }
    }
    
}

