//
//  TableViewController.swift
//  ToDoListApp
//
//  Created by Евгений on 02.07.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    // Загрузка окна
    override func viewDidLoad() {
        super.viewDidLoad()
        // Включили возможность нажатия на ячейку
        // во время режима редактирования
        tableView.allowsSelectionDuringEditing = true
    }

    // Количество секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Количество строк в секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItems.count
    }

    // Публикация в строке секции
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Создание строки
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Присвоение строке задачи
        cell.textLabel?.text = arrayItems[indexPath.row]["name"] as? String
        // Проверка выполнена задача или нет
        // Расстановка галочек
        let isDone = arrayItems[indexPath.row]["isDone"] as! Bool
        if isDone {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    // Кнопка добавления новой записи
    @IBAction func addItemButtonPressed(_ sender: Any) {
        // Создание модального окна для добавления новой записи
        let alertController = UIAlertController(title: "Новая задача", message: "", preferredStyle: UIAlertControllerStyle.alert)
        // Создание текстового поля для задачи
        alertController.addTextField { (textField) in
            textField.placeholder = "Название"
        }
        // Кнопка добавления новой записи
        let addAlert = UIAlertAction(title: "Добавить", style: UIAlertActionStyle.default) { (alert) in
            if alertController.textFields![0].text! != "" {
                let newDict = ["name": alertController.textFields![0].text!, "isDone": false, "color": "white"] as [String : Any]
                arrayItems.append(newDict)
                self.tableView.reloadData()
            }
        }
        // Кнопка отмены создания новой записи
        let cancelAlert = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default) { (alert) in
            
        }
        // Добавление кнопок в модальное окно
        alertController.addAction(cancelAlert)
        alertController.addAction(addAlert)
        // Перенаправление после нажатия кнопки на модальное окно
        present(alertController, animated: true, completion: nil)
    }
    
    // Нажатие кнопки редактирования
    @IBAction func editItemButtonPressed(_ sender: Any) {
        // Включение режима редактирования
        // Если включен режим, то выключаем его
        // Если выключен - включаем
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    // Нажатие на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Длеаем короткое нажатие
        tableView.deselectRow(at: indexPath, animated: false)
        // Переменная ячейки для обращения
        let cell = tableView.cellForRow(at: indexPath)
        // Проверка находится в режиме редактирования или нет
        if !tableView.isEditing {
            // Обработка события короткого нажатия на ячейку
            // Убираем или ставим галочку
            // Изменяем состояние в массиве
            let isDone = arrayItems[indexPath.row]["isDone"] as! Bool
            if isDone {
                cell?.accessoryType = .none
                arrayItems[indexPath.row]["isDone"] = false
            } else {
                cell?.accessoryType = .checkmark
                arrayItems[indexPath.row]["isDone"] = true
            }
        } else {
            // Создание модального окна для редактирования задачи
            let alertController = UIAlertController(title: "Редактирование задачи", message: "", preferredStyle: UIAlertControllerStyle.alert)
            // Добавление текстового поля
            // Присвоение текстовому полю имеющееся значение
            alertController.addTextField { (textField) in
                textField.placeholder = "Название"
                textField.text = arrayItems[indexPath.row]["name"] as? String
            }
            // Создание кнопки изменения
            let editAlert = UIAlertAction(title: "Изменить", style: UIAlertActionStyle.default) { (alert) in
                if alertController.textFields![0].text! != "" {
                    // Меняем значение в массиве на новое,
                    // которое ввел пользователь в текстовом поле
                    arrayItems[indexPath.row]["name"] = alertController.textFields![0].text!
                    // Обновление данных
                    tableView.reloadData()
                }
            }
            // Создание кнопки отмены
            let cancelAlert = UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default) { (alert) in }
            // Добавление кнопок на модальное окно
            alertController.addAction(cancelAlert)
            alertController.addAction(editAlert)
            // Перенаправление пользователя на модальное окно
            // после нажатия на ячейку в режиме редактирования
            present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Событие свайпа строки влево
    // Удаление строки из таблицы
    // Удаление элемента из массива
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrayItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Реализация изменения позиции строк
    // Меняем элементы местами в массиве
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let fromItem = arrayItems[fromIndexPath.row]
        arrayItems.remove(at: fromIndexPath.row)
        arrayItems.insert(fromItem, at: to.row)
    }
    
    // Разрешает переносить любую ячейку
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
