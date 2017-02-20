//
//  LocalServices.swift
//  Rappi
//
//  Created by Johan Vallejo on 19/02/17.
//  Copyright © 2017 kijho. All rights reserved.
//

import Foundation
import CoreData

class LocalServices {
    let remoteService = Services()
    let stack = CoreDataStack.sharedInstance

    func getCategories(localHandler: @escaping ([CategoryApp]?) -> Void, remoteHandler: @escaping ([CategoryApp]?) -> Void) {
        //Obtengo la información de CoreData
        localHandler(self.getCategoriesCoreData())

        remoteService.getCategories() { categories in
            if let categories = categories {
                self.markAllCategoriesAsUnsync()

                for categoryDictionary in categories {
                    if let category = self.getCategoryById(id: categoryDictionary["id"]!) {
                        self.updateCategory(categoryDictionary: categoryDictionary, category: category)
                    } else {
                        self.insertCategory(categoryDictionary: categoryDictionary)
                    }
                }
                self.removeOldCategories()
                remoteHandler(self.getCategoriesCoreData())
            } else {
                remoteHandler(nil)
            }
        }
        
    }

    func getApps(localHandler: @escaping ([App]?) -> Void, remoteHandler: @escaping ([App]?) -> Void) {
        
    }
    

    //Buscamos en CoreData las categorias
    func getCategoriesCoreData() -> [CategoryApp]? {
        let context = stack.persistentContainer.viewContext
        let request: NSFetchRequest<CategoryManaged> = CategoryManaged.fetchRequest()

        do {
            let fetchedCategories = try context.fetch(request)
            var categories = [CategoryApp]()

            for manageCategory in fetchedCategories {
                categories.append(manageCategory.mappedObject())
            }
            return categories

        } catch {
            print("Error categorías de CoreData")
            return nil
        }
    }

    //Marcamos todas las categorias como no sincronizadas
    func markAllCategoriesAsUnsync() {
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<CategoryManaged> = CategoryManaged.fetchRequest()

        do {
            let fetchedCategories = try context.fetch(request)
            for managedCategory in fetchedCategories {
                managedCategory.sync = false
            }
            try context.save()
        } catch {
            print("Error cambiando el valor de la sincronizació en Core Data")
        }
    }

    //Obtenemos una categoría por el ID
    func getCategoryById(id: String) -> CategoryManaged? {
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<CategoryManaged> = CategoryManaged.fetchRequest()
        let predicate = NSPredicate(format: "id = \(id)")
        
        request.predicate = predicate
        do {
            let fetchedCategories = try context.fetch(request)
            
            if fetchedCategories.count > 0 {
                return fetchedCategories.last
            } else {
                return nil
            }
        } catch {
            print("Error obteniendo la categoría de Core Data")
            return nil
        }
    }

    //Insertar Categoría
    func insertCategory(categoryDictionary: [String : String]) {
        let context = stack.persistentContainer.viewContext
        let category = CategoryManaged(context: context)
        category.id = categoryDictionary["id"]
        updateCategory(categoryDictionary: categoryDictionary, category: category)
        
    }

    //Actualizar Categoría
    func updateCategory(categoryDictionary: [String : String], category: CategoryManaged) {
        let context = stack.persistentContainer.viewContext
        category.name = categoryDictionary["name"]
        category.sync = true
        
        do {
            try context.save()
        } catch {
            print("Error actualizando categoría en Core Data")
        }
    }

    //Eliminamos categorias que hayan salido del top
    func removeOldCategories() {
        let context = stack.persistentContainer.viewContext
        let request: NSFetchRequest<CategoryManaged> = CategoryManaged.fetchRequest()
        let predicate = NSPredicate(format: "sync = \(false)")
        request.predicate = predicate
        
        do {
            let fetchedCategories = try context.fetch(request)
            for manageCategory in fetchedCategories {
                if !manageCategory.sync {
                    context.delete(manageCategory)
                }
            }

            try context.save()
        } catch {
            print("Error borrando categoría de Core Data")
        }
    }
    
    //----------------------------APP---------------------------------------------
    func getApps(categoryId: String, localHandler: @escaping ([App]?) -> Void, remoteHandler: @escaping ([App]?) -> Void) {
        //Obtengo la información de CoreData
        
        localHandler(self.getAppCoreData(categoryId: categoryId))
        
        remoteService.getAppInformation() { apps in
            if let apps = apps {
                self.markAllAppsAsUnsync()
                
                for appDictionary in apps {
                    if let app = self.getAppById(id: appDictionary["id"]!) {
                        self.updateApp(appDictionary: appDictionary, app: app)
                    } else {
                        self.insertApp(appDictionary: appDictionary)
                    }
                }
                self.removeOldApps()
                remoteHandler(self.getAppCoreData(categoryId: categoryId))
            } else {
                remoteHandler(nil)
            }
        }
        
    }
    
    //Marcamos todas las Apps como no sincronizadas
    func markAllAppsAsUnsync() {
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<AppManaged> = AppManaged.fetchRequest()
        
        do {
            let fetchedApps = try context.fetch(request)
            for managedApp in fetchedApps {
                managedApp.sync = false
            }
            try context.save()
        } catch {
            print("Error cambiando el valor de la sincronizació en Core Data")
        }
    }
    
    //Buscamos en CoreData las App
    func getAppCoreData(categoryId: String) -> [App]? {
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<AppManaged> = AppManaged.fetchRequest()

        let predicate = NSPredicate(format: "categoryId = \(categoryId)")
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchedCategories = try context.fetch(request)
            var apps = [App]()
            
            for manageApp in fetchedCategories {
                apps.append(manageApp.mappedObject())
            }

            return apps
            
        } catch {
            print("Error categorías de CoreData")
            return nil
        }
    }
    
    //Obtenemos una categoría por el ID
    func getAppById(id: String) -> AppManaged? {
        let context = stack.persistentContainer.viewContext
        let request : NSFetchRequest<AppManaged> = AppManaged.fetchRequest()
        let predicate = NSPredicate(format: "id = \(id)")
        request.predicate = predicate
        
        do {
            let fetchedApps = try context.fetch(request)
            
            if fetchedApps.count > 0 {
                return fetchedApps.last
            } else {
                return nil
            }
        } catch {
            print("Error obteniendo la app de Core Data")
            return nil
        }
    }
    
    //Insertar App
    func insertApp(appDictionary: [String : String]) {
        let context = stack.persistentContainer.viewContext
        let app = AppManaged(context: context)
        app.id = appDictionary["id"]
        updateApp(appDictionary: appDictionary, app: app)
        
    }
    
    //Actualizar App
    func updateApp(appDictionary: [String : String], app: AppManaged) {
        let context = stack.persistentContainer.viewContext
        app.name = appDictionary["name"]
        app.categoryId = appDictionary["categoryId"]
        app.artist = appDictionary["artist"]
        app.price = appDictionary["price"]
        app.summary = appDictionary["summary"]
        app.image = appDictionary["image"]
        app.sync = true
        
        do {
            try context.save()
        } catch {
            print("Error actualizando app en Core Data")
        }
    }
    
    //Eliminamos Apps que hayan salido del top
    func removeOldApps() {
        let context = stack.persistentContainer.viewContext
        let request: NSFetchRequest<AppManaged> = AppManaged.fetchRequest()
        let predicate = NSPredicate(format: "sync = \(false)")
        request.predicate = predicate
        
        do {
            let fetchedApps = try context.fetch(request)
            for manageApp in fetchedApps {
                if !manageApp.sync {
                    context.delete(manageApp)
                }
            }
            
            try context.save()
        } catch {
            print("Error borrando app de Core Data")
        }
    }
    
    
}
