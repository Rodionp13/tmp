//
//  AppDelegate.swift
//  GifTask
//
//  Created by Yauheni Kamesh on 8/21/18.
//  Copyright © 2018 Yauheni Kamesh. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class RLAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var presenter: Presenter2!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController(rootViewController: RLMainViewController.init())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        self.presenter = Presenter2.init()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if let configs = self.presenter.getConfigArr() {
            if(self.presenter.saveConfigToDb(configArr: configs)) { print("Success archived data") }
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "downloaderGifs")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

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

