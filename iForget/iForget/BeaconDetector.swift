//
//  BeaconDetector.swift
//  iForget
//
//  Created by Neso on 2020/06/08.
//  Copyright © 2020 Rainlab. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class BeaconDetector: NSObject, ObservableObject, CLLocationManagerDelegate {

	private let locationManager = CLLocationManager()

	@Published private (set) var permissionGranted = false
	private (set) var exists = PassthroughSubject<CLBeaconRegion, Never>()

	override init() {
		super.init()
		locationManager.delegate = self // let's listen for events
		locationManager.requestAlwaysAuthorization() // we need use location always in order to monitor beacons in background
	}

	// let's implement the events
	// we need two events
	// location permission and exit the beacon region

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse || status == .authorizedAlways {
			// in case we may want to ask user if they don't authorize location permission
			// let ui know in this case
			publish(permissionGranted: true)
			// let's check can we monitor beacons
			if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
				// start the monitoring
				startMonitoring()
				return
			}
		}
		publish(permissionGranted: false)
	}

	func publish(permissionGranted: Bool) {
		DispatchQueue.main.async {
			self.permissionGranted = permissionGranted
		}
	}

	func startMonitoring() {
		// let me explain this by run BeaconEmitter application that we mentioned in earlier
		// UUID as you know what is it, identifier for iBeacon
		// Major is kind of branch or think of a build's floor, here my case is 3rd floor
		// Minor is kind of subbranch or think of the build's room in that floor which is 1 for case
		let beaconRegion = CLBeaconRegion(uuid: UUID(uuidString: "77048D46-2AB4-44B2-9C72-2764B8A899C5")!, major: 3, minor: 1, identifier: "Your Room")
		locationManager.startMonitoring(for: beaconRegion)
	}

	func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
		// Please note that; this will occur for many cases we want only for beacon region
		// let's guard it!
		guard let beaconRegion = region as? CLBeaconRegion else { return }
		// let's notify our subscribers
		exists.send(beaconRegion)
	}

}
