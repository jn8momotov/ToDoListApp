//
//  ListItems.swift
//  ToDoListApp
//
//  Created by Евгений on 02.07.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import Foundation

// Хранение данных и сохранение состояния
// при помощи UserDefaults
var arrayItems: [[String: Any]] {
    get {
        let array = UserDefaults.standard.array(forKey: "Key")
        if array == nil {
            return []
        } else {
            return array as! [[String : Any]]
        }
    }
    set {
        // Добавление/изменение элемента
        UserDefaults.standard.set(newValue, forKey: "Key")
        // Синхронизация
        UserDefaults.standard.synchronize()
    }
}
