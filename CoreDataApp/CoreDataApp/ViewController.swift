//
//  ViewController.swift
//  CoreDataApp
//
//  Created by class24 on 2016/9/6.
//  Copyright © 2016年 GUO. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var chineseTextField: UITextField!
    @IBOutlet weak var mathTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cleanButton: UIButton!
    @IBOutlet weak var addButton: UIButton!

   
    // 目前陣列索引值
    var currentNumber: Int = 0
    // 建立 AppDelegate 類別：取得「管理物件文件」需要
    var appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    // 存放管理物件文件
    var context: NSManagedObjectContext!
    // 儲存文件內容資料
    var result: [Student] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // 建立管理物件文本內容資料的物件
        context = appDelegate.managedObjectContext
        
        // 建立取得文本內容的資料：填寫表單名稱
        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Student")
        // 進行取得文本內容
        do {
            try result = context.executeFetchRequest(fetchRequest) as! [Student]
        } catch _ {
            
        }
        // tableView 屬性
        self.tableView.dataSource = self
        self.tableView.delegate  = self
        
        if self.result.count != 0 {
            // 顯示第一筆資料內容
            self.showSigleData(currentNumber)
        } else {
            // 初始化資料表
            self.initData()
        }
        
        // 設定畫面物件屬性
        self.nameTextField.enabled = false  // 無法進行修改姓名
        self.cleanButton.enabled = true     // 可以清除欄位中的資料
        self.addButton.enabled = false      // 無法進行新增資料
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func deleteAction(sender: UIButton) {
    }
    @IBAction func updateAction(sender: UIButton) {
    }
    @IBAction func cleanAction(sender: UIButton) {
        self.nameTextField.enabled = true   // 開啟姓名欄位填寫功能
        self.nameTextField.text = ""        // 清空欄位內容
        self.chineseTextField.text = ""
        self.mathTextField.text = ""
        self.cleanButton.enabled = false    // 關閉清除按鈕功能
        self.addButton.enabled = true       // 開啟新增按鈕功能
    }
    @IBAction func addAction(sender: UIButton) {
        
        if self.nameTextField.text == "" || self.chineseTextField.text == "" || self.mathTextField.text == "" {
            self.showAlert("錯誤", message: "填寫欄位未完整！")
            return
        }
    
        self.nameTextField.enabled = false  // 關閉姓名欄位填寫功能
        self.cleanButton.enabled = true
        self.addButton.enabled = false
        // 準備新增一筆Student資料環境
        let student: Student = NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: context) as! Student
        student.name = self.nameTextField.text!
        student.chinese = NSNumber(integer: Int(self.chineseTextField.text!)!)
        student.math = NSNumber(integer: Int(self.mathTextField.text!)!)
        // 儲存資料
        self.appDelegate.saveContext()
        
        // 重新讀取資料
        let fetchRequest = NSFetchRequest(entityName: "Student")
        do {
            try result = context.executeFetchRequest(fetchRequest) as! [Student]
        } catch let error {
            print("Error: \(error)")
        }
        
        // 重新整理表單
        self.tableView.reloadData()
        
        // 顯示最後一筆資料內容
        self.currentNumber = self.result.count - 1
        self.showSigleData(self.currentNumber)
        
    }

    
    // 初始化資料表內容
    func initData() {
        /*
         1. 當資料表沒有資料時，自動增加兩筆資料
         2. 新增資料方式為：逐筆新增、逐筆儲存
         */
        
        if self.result.count == 0 {
            // 1.新增一個 Student Row
            var student = NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: context) as! Student
            // 2.輸入 student 資料
            student.name = "Guo"
            student.chinese = 70
            student.math = 80
            // 3.儲存資料
            appDelegate.saveContext()
            
            // 1.新增一個 Student Row
            student = NSEntityDescription.insertNewObjectForEntityForName("Student", inManagedObjectContext: context) as! Student
            // 2.輸入 student 資料
            student.name = "Wang"
            student.chinese = 90
            student.math = 70
            // 3.儲存資料
            appDelegate.saveContext()
            
            
            // 重新讀取資料
            let fetchRequest = NSFetchRequest(entityName: "Student")
            
            // 進行取得文本內容
            do {
                try result = context.executeFetchRequest(fetchRequest) as! [Student]
            } catch _ {
                
            }
            // 重新整理表單
            self.tableView.reloadData()
            
            // 顯示最後一筆資料內容
            self.showSigleData(self.currentNumber)
        }
        
        
    }
    // 顯示第一筆資料
    func showSigleData(indexNumber: Int) {
        self.nameTextField.text = self.result[indexNumber].name!
        self.chineseTextField.text = String(self.result[indexNumber].chinese!)
        self.mathTextField.text = String(self.result[indexNumber].math!)
    }
    
    // 顯示提示訊息
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .Default, handler: { (btn1) in
            
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    // 顯示更新訊息
    func updateAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (btn1) in
            
        }))
        alertController.addAction(UIAlertAction(title: "確定", style: .Default, handler: { (btn1) in
            
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    // 顯示刪除訊息
    func deleteAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (btn1) in
            
        }))
        alertController.addAction(UIAlertAction(title: "確定", style: .Default, handler: { (btn1) in
            
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.result.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = self.result[indexPath.row].name!
        cell.detailTextLabel!.text = "國文成績：\(self.result[indexPath.row].chinese!)，數學成績：\(self.result[indexPath.row].math!)"
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.nameTextField.enabled = false
        self.cleanButton.enabled = true
        self.addButton.enabled = false
        self.currentNumber = indexPath.row
        self.showSigleData(self.currentNumber)
    }
}