//
//  CloudKitManager.swift
//  Timeline
//
//  Created by Andrew Madsen on 6/18/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

private let CreatorUserRecordIDKey = "creatorUserRecordID"
private let LastModifiedUserRecordIDKey = "creatorUserRecordID"
private let CreationDateKey = "creationDate"
private let ModificationDateKey = "modificationDate"

class CloudKitManager {
    
	let database = CKContainer.default().publicCloudDatabase
	
	func fetchRecords(ofType type: String,
	                          sortDescriptors: [NSSortDescriptor]? = nil,
	                          completion: @escaping ([CKRecord]?, Error?) -> Void) {
		
		let query = CKQuery(recordType: type, predicate: NSPredicate(value: true))
		query.sortDescriptors = sortDescriptors
		
		database.perform(query, inZoneWith: nil, completionHandler: completion)
	}
	
	func save(_ record: CKRecord, completion: @escaping ((Error?) -> Void) = { _ in }) {
		
		database.save(record, completionHandler: { (record, error) in
			completion(error)
		}) 
	}
	
	func subscribeToCreationOfRecords(ofType type: String, completion: @escaping ((Error?) -> Void) = { _ in }) {
		let subscription = CKSubscription(recordType: Message.recordType, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
		let notificationInfo = CKNotificationInfo()
		notificationInfo.alertBody = "There's a new message on the bulletin board."
		notificationInfo.soundName = UILocalNotificationDefaultSoundName
		subscription.notificationInfo = notificationInfo
		database.save(subscription, completionHandler: { (subscription, error) in
			if let error = error {
				NSLog("Error saving subscription: \(error)")
			}
			completion(error)
		}) 
	}
}
