//
//  MessagesController.swift
//  BulletinBoard
//
//  Created by Andrew Madsen on 6/18/16.
//  Copyright © 2016 Open Reel Software. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

extension MessagesController {
	static let DidRefreshNotification = Notification.Name("DidRefreshNotification")
}

class MessagesController {
	static let sharedController = MessagesController()
	
	init() {
		refresh()
	}
	
	// MARK: Public Methods
	
	func postNewMessage(_ message: Message, completion: ((Error?) -> Void)? = nil) {
		let record = message.cloudKitRecord
		
		cloudKitManager.saveRecord(message.cloudKitRecord) { (error) in
			defer { completion?(error) }
			if let error = error {
				NSLog("Error saving \(message) to CloudKit: \(error)")
				return
			}
			self.messages.append(message)
		}
	}
	
	func refresh(_ completion: ((Error?) -> Void)? = nil) {
		let sortDescriptors = [NSSortDescriptor(key: Message.dateKey, ascending: false)]
		cloudKitManager.fetchRecordsWithType(Message.recordType, sortDescriptors: sortDescriptors) {
			(records, error) in
			
			defer { completion?(error) }
			
			if let error = error {
				NSLog("Error fetching messages: \(error)")
				return
			}
			guard let records = records else { return }
			
			self.messages = records.flatMap { Message(cloudKitRecord: $0) }
		}
	}
	
	func subscribeForPushNotifications(_ completion: ((Error?) -> Void)? = nil) {
		
		cloudKitManager.subscribeToCreationOfRecordsWithType(Message.recordType) { (error) in
			if let error = error {
				NSLog("Error saving subscription: \(error)")
			} else {
				NSLog("Subscribed to push notifications for new messages")
			}
			completion?(error)
		}
	}
	
	// MARK: Private Methods
	
	// MARK: Public Properties
	
	private(set) var messages = [Message]() {
		didSet {
			DispatchQueue.main.async { 
				let nc = NotificationCenter.default
				nc.post(name: MessagesController.DidRefreshNotification, object: self)
			}
		}
	}
	
	// MARK: Private Properties
	
	private let cloudKitManager = CloudKitManager()
	
}
