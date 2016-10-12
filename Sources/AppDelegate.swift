//
//  AppDelegate.swift
//  BulletinBoard
//
//  Created by Andrew Madsen on 6/18/16.
//  Copyright © 2016 Open Reel Software. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
		UIApplication.shared.registerUserNotificationSettings(notificationSettings)
		
		return true
	}
	
	func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
		UIApplication.shared.registerForRemoteNotifications()
		MessagesController.sharedController.subscribeToPushNotifications()
	}

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
		MessagesController.sharedController.refresh()
	}


}

