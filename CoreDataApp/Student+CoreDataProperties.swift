//
//  Student+CoreDataProperties.swift
//  CoreDataApp
//
//  Created by class24 on 2016/9/6.
//  Copyright © 2016年 GUO. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
// CoreData 表所轉出來的子類別檔案擴充屬性編輯區域

import Foundation
import CoreData

extension Student {

    @NSManaged var name: String?
    @NSManaged var chinese: NSNumber?
    @NSManaged var math: NSNumber?

}
