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
	static let shared = MessagesController()
	
	init() {
		refresh()
	}
	
	// MARK: Public Methods
	
	func post(message: Message, completion: @escaping ((Error?) -> Void) = { _ in }) {
		let record = message.cloudKitRecord
		
		cloudKitManager.save(message.cloudKitRecord) { (error) in
			defer { completion(error) }
			if let error = error {
				NSLog("Error saving \(message) to CloudKit: \(error)")
				return
			}
			self.messages.append(message)
		}
	}
	
	func refresh(completion: @escaping ((Error?) -> Void) = { _ in }) {
		let sortDescriptors = [NSSortDescriptor(key: Message.dateKey, ascending: false)]
		cloudKitManager.fetchRecords(ofType: Message.recordType, sortDescriptors: sortDescriptors) {
			(records, error) in
			
			defer { completion(error) }
			
			if let error = error {
				NSLog("Error fetching messages: \(error)")
				return
			}
			guard let records = records else { return }
			
			self.messages = records.flatMap { Message(cloudKitRecord: $0) }
		}
	}
	
	func subscribeToPushNotifications(completion: @escaping ((Error?) -> Void) = { _ in }) {
		
		cloudKitManager.subscribeToCreationOfRecords(ofType: Message.recordType) { (error) in
			if let error = error {
				NSLog("Error saving subscription: \(error)")
			} else {
				NSLog("Subscribed to push notifications for new messages")
			}
			completion(error)
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
