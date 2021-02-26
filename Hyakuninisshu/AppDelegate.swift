//
//  AppDelegate.swift
//  Hyakuninisshu
//
//  Created by Rei Matsushita on 2020/11/27.
//

import AdSupport
import AppTrackingTransparency
import CoreData
import Firebase
import GoogleMobileAds
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  lazy var diContainer = DIContainer(container: persistentContainer)

  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Hyakuninisshu")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        let window = UIApplication.shared.windows.last
        let storyboard = UIStoryboard(name: "Error", bundle: nil)
        window?.rootViewController = storyboard.instantiateViewController(identifier: .fatalError)
        window?.makeKeyAndVisible()
      }
    })

    return container
  }()

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Override point for customization after application launch.
    Env.shared.configure()
    FirebaseApp.configure()
    if #available(iOS 14, *) {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
        GADMobileAds.sharedInstance().start(completionHandler: nil)
      })
    } else {
      // Fallback on earlier versions
      GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    #if DEBUG
      switch Env.shared.value(.testDeviceIdentifier) {
      case .some(let testDeviceIdentifier):
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [
          testDeviceIdentifier
        ]
      case .none: break
      }
    #endif

    return true
  }

  // MARK: UISceneSession Lifecycle
  func application(
    _ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.

    return UISceneConfiguration(
      name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(
    _ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>
  ) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}
