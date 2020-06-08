//
//  NotificationService.swift
//  iForget
//
//  Created by Neso on 2020/06/08.
//  Copyright © 2020 Rainlab. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService: NSObject, ObservableObject {

	@Published private (set) var permissionGranted = false

	override init() {
		super.init()
		self.requestPermission()
	}

	func requestPermission() {
		let notification = UNUserNotificationCenter.current()
		let options: UNAuthorizationOptions = [.alert, .sound]

		notification.requestAuthorization(options: options) { didAllow, _ in
			DispatchQueue.main.async {
				self.permissionGranted = didAllow
			}
		}
		// and let's check authorization
		// it's going to check it everytime
		checkAuthorization()
	}

	// we also need to check that user change the permission manually from settings
	func checkAuthorization() {
		UNUserNotificationCenter.current().getNotificationSettings { settings in
			// okay since these permissions are going to be handle on UI
			// better to send via main thread
			DispatchQueue.main.async {
				self.permissionGranted = settings.authorizationStatus == .authorized
			}
		}
	}

	// last function
	// send the push

	func show(title: String, message: String, withSound: Bool = true) {
		let push = UNMutableNotificationContent()
		push.title = title
		push.body = message

		if withSound {
			push.sound = .default
		}
		// let's give a fixed identifier to the push
		// avoid notification noise
		// it will update the same push always
		// so you won't have the noise on your screen
		let request = UNNotificationRequest(identifier: "iForget", content: push, trigger: nil)
		// let's send the push
		UNUserNotificationCenter.current().add(request)
	}

}
