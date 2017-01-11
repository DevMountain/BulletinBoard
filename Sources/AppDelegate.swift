//
//  AppDelegate.swift
//  BulletinBoard
//
//  Created by Andrew Madsen on 6/18/16.
//  Copyright © 2016 Open Reel Software. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (success, error) in
			if let error = error {
				NSLog("Error requesting authorization for notifications: \(error)")
				return
			}
		}
		
		UIApplication.shared.registerForRemoteNotifications()
		
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		MessagesController.shared.subscribeToPushNotifications()
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		NSLog("Error registering for remote notifications: \(error)")
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
		MessagesController.shared.refresh()
	}


}

