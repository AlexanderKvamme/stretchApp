//
//  AppDelegate.swift
//  Stretchapp
//
//  Created by Alexander Kvamme on 20/03/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        UITextField.appearance().tintColor = .black

        seedDatabaseIfNeeded()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    private func seedDatabaseIfNeeded() {

        if DAO.getWorkouts().filter({ (workout) -> Bool in
            workout.name == Workout.gabos.name
        }).count == 0 {
            DAO.saveWorkout(Workout.gabos)
        } else {
            guard UIApplication.isRunningTest else {
                return
            }

            // Delete
            DAO.getWorkouts().forEach{ DAO.deleteWorkout($0) }

            // Seed
            DAO.saveWorkout(Workout.gabos)
            DAO.saveWorkout(Workout.forUITesting)
            DAO.saveWorkout(Workout.dummy)
        }
    }
}

extension UIApplication {
    public static var isRunningTest: Bool {
        return ProcessInfo().arguments.contains("--UITEST")
    }
}
