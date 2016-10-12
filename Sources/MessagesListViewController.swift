//
//  MessagesListViewController.swift
//  BulletinBoard
//
//  Created by Andrew Madsen on 6/18/16.
//  Copyright © 2016 Open Reel Software. All rights reserved.
//

import UIKit

class MessagesListViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let nc = NotificationCenter.default
		nc.addObserver(self,
		               selector: #selector(messagesWereUpdated(_:)),
		               name: MessagesController.DidRefreshNotification,
		               object: nil)
	}

	@IBAction func post(_ sender: UIButton) {
		guard let messageText = textField.text else { return }
		textField.resignFirstResponder()
		let message = Message(messageText: messageText, date: Date())
		MessagesController.sharedController.postNewMessage(message)
	}
	
	func messagesWereUpdated(_ notification: Notification) {
		tableView?.reloadData()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	// MARK: UITableViewDelegate/Datasource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return MessagesController.sharedController.messages.count
	}
	
	let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.doesRelativeDateFormatting = true
		formatter.timeStyle = .short
		return formatter
	}()
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") else {
			return UITableViewCell()
		}
		
		let messages = MessagesController.sharedController.messages
		let message = messages[(indexPath as NSIndexPath).row]
		
		cell.textLabel?.text = message.messageText
		cell.detailTextLabel?.text = dateFormatter.string(from: message.date as Date)
		
		return cell
	}
	
	@IBOutlet var textField: UITextField!
	@IBOutlet var tableView: UITableView!
}
