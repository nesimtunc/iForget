//
//  SessionController.swift
//  iForget
//
//  Created by Neso on 2020/06/08.
//  Copyright © 2020 Rainlab. All rights reserved.
//

import Foundation
import Combine

class SessionController: ObservableObject {

	private let beaconDetector = BeaconDetector()
	private let notificationService = NotificationService()
	private let message = UserDefaults.standard.string(forKey: "message") ?? ""

	private var beaconExitEventCanceller: AnyCancellable? = nil

	init() {
		// we need to listen for beacon events (there's only one currently)
		// and when we receive it we'll send push using notifcationService
		self.beaconExitEventCanceller = self.beaconDetector.exists.sink { beaconRegion in
			// here we send notification

			let title = "Did you forget from \(beaconRegion.identifier)"
			self.notificationService.show(title: title, message: self.message) // let's read the message from UserDefaults, right?
		}
	}

	// I think that's all!! Bear in mind, we can't test the beacon on simulator, so I'm going to install the application on my device
	// I'll share the screen
	// Oh I just remember that we need add some permission string in Info.plist but let's first see the error
}
