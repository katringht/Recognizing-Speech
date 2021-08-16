//
//  ViewControllerExtention.swift
//  SpeechRecognition
//
//  Created by Ekaterina Tarasova on 13.08.2021.
//

import UIKit

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySpeechR.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        let spc = mySpeechR[indexPath.row]
        cell.cellSpeechText.text = spc.speechtext
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let spch = mySpeechR[indexPath.row]
            let context = DataManager.shared.persistentContainer.viewContext
            context.delete(spch)
            tableView.reloadData()
            do {
                try context.save()
                mySpeechR.remove(at: indexPath.row)
            } catch {
                print("error")
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
