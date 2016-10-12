//
//  Message+CloudKit.swift
//  BulletinBoard
//
//  Created by Andrew Madsen on 6/18/16.
//  Copyright © 2016 Open Reel Software. All rights reserved.
//

import Foundation
import CloudKit

extension Message {
	
	static var recordType: String { return "Message" }
	static var messageTextKey: String { return "MessageText" }
	static var dateKey: String { return "Date" }
	
	init?(cloudKitRecord: CKRecord) {
		guard let messageText = cloudKitRecord[Message.messageTextKey] as? String,
			date = cloudKitRecord.creationDate ?? (cloudKitRecord[Message.dateKey] as? NSDate)
			where cloudKitRecord.recordType == Message.recordType else { return nil }
		
		self.init(messageText: messageText, date: date)
	}
	
	var cloudKitRecord: CKRecord {
		let record = CKRecord(recordType: Message.recordType)
		record[Message.messageTextKey] = messageText
		record[Message.dateKey] = date
		return record
	}
}
