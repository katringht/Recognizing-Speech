//
//  DataManager.swift
//  SpeechRecognition
//
//  Created by Ekaterina Tarasova on 13.08.2021.
//

import UIKit
import CoreData

class DataManager {
    static let shared = DataManager()
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SpeechRecognition")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func mySpeeches(text: String) -> SpeachRecog {
        let sp = SpeachRecog(context: persistentContainer.viewContext)
        sp.speechtext = text
        return sp
    }
    
    func fetchData() -> [SpeachRecog] {
        let request: NSFetchRequest<SpeachRecog> = SpeachRecog.fetchRequest()
        var fetchedMySpeech: [SpeachRecog] = []
        
        do {
            fetchedMySpeech = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fething")
        }
        return fetchedMySpeech
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
