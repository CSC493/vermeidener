//
//  ViewController.swift
//  Image Test
//
//  Created by Christopher Primerano on 2015-01-26.
//  Copyright (c) 2015 Christopher Primerano. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion


class ViewController: UIViewController {
	
	let stillImageOutput = AVCaptureStillImageOutput()
	let session = AVCaptureSession()
	var count = 0
	
	let cmManager = CMMotionManager()
	
	var dataPoints = [CMDeviceMotion]()
	
	var images = [UIImage]()
	
	private let frequency = 1.0 / 1.0

	@IBOutlet weak var leftImage: UIImageView!
	@IBOutlet weak var rightImage: UIImageView!
	
	
	
	func frontFacingCameraIfAvailable() -> AVCaptureDevice {
		
		let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
		var captureDevice: AVCaptureDevice! = nil
		
		for device in videoDevices {
			if (device.position == AVCaptureDevicePosition.Front) {
				captureDevice = device as AVCaptureDevice
				break
			}
		}
		
		if (captureDevice == nil) {
			captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
		}
		
		return captureDevice
	}
	
	func rearFacingCameraIfAvailable() -> AVCaptureDevice {
		
		let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
		var captureDevice: AVCaptureDevice! = nil
		
		for device in videoDevices {
			if (device.position == AVCaptureDevicePosition.Back) {
				captureDevice = device as AVCaptureDevice
				break
			}
		}
		
		if (captureDevice == nil) {
			captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
		}
		
		return captureDevice
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.session.sessionPreset = AVCaptureSessionPresetLow
		
		let device = self.rearFacingCameraIfAvailable()
		let deviceInput = AVCaptureDeviceInput(device: device, error: nil)
		
		if (self.session.canAddInput(deviceInput)) {
			self.session.addInput(deviceInput)
		}
		
		let outputSettings: NSDictionary = [AVVideoCodecKey: AVVideoCodecJPEG]
		
		self.stillImageOutput.outputSettings = outputSettings as [NSObject : AnyObject]
		
		if (self.session.canAddOutput(self.stillImageOutput)) {
			self.session.addOutput(self.stillImageOutput)
		}
		
		self.session.startRunning()
		
	}
	
	override func viewDidAppear(animated: Bool) {
		cmManager.deviceMotionUpdateInterval = frequency
		cmManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()) {
			if ($1 == nil) {
				if (self.dataPoints.count > 2 && self.images.count > 2) {
					self.dataPoints.removeAtIndex(0)
					self.images.removeAtIndex(0)
//					self.displayData()
//					dispatch_async(dispatch_get_main_queue()) {self.updateUI()}
					dispatch_async(dispatch_get_main_queue()) {
						let disp = Map.disparityMap(self.images[0], andRight: self.images[1])
						self.leftImage.image = disp
//						self.rightImage.image = disp
					}
//					println("\(Map.disparityMap(self.images[0], andRight: self.images[1]))")
				}
				self.dataPoints.append($0)
				self.captureImage()
			}
		}
	}
	
	override func viewDidDisappear(animated: Bool) {
		cmManager.stopDeviceMotionUpdates()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func displayData() {
//		println("\(self.dataPoints[0])")
//		println("\(self.dataPoints[1])")
		
		let displacement = self.dataPoints[1].userAcceleration.displacement(self.dataPoints[0].userAcceleration, time: abs(self.dataPoints[1].timestamp - self.dataPoints[0].timestamp))
		
		println("Displacement = \(displacement)")
		let length = displacement.length
		println("Distance = \(length)")
		println("Time = \(abs(self.dataPoints[1].timestamp - self.dataPoints[0].timestamp))")
		println("attitudes = \(self.dataPoints[0].attitude.quaternion.vector), \(self.dataPoints[0].attitude.quaternion.theta); \(self.dataPoints[1].attitude.quaternion.vector), \(self.dataPoints[1].attitude.quaternion.theta)")
		println("lengths = \(self.dataPoints[0].attitude.quaternion.length); \(self.dataPoints[1].attitude.quaternion.length)")
//		self.dataPoints[1].attitude.multiplyByInverseOfAttitude(self.dataPoints[0].attitude)
		let inverse = CMQuaternion(x: -self.dataPoints[0].attitude.quaternion.x, y: -self.dataPoints[0].attitude.quaternion.y, z: -self.dataPoints[0].attitude.quaternion.z, w: self.dataPoints[0].attitude.quaternion.w)
		let newQuaternion = inverse.multiply(self.dataPoints[1].attitude.quaternion)
		println("Attitude = \(newQuaternion.vector), \(newQuaternion.theta)")
		println("length = \(newQuaternion.length)")
		println()
	}
	
	func captureImage() {
		var videoConnection: AVCaptureConnection! = nil
		
		for connection in self.stillImageOutput.connections {
			for port in (connection as AVCaptureConnection).inputPorts {
				if ((port as AVCaptureInputPort).mediaType == AVMediaTypeVideo) {
					videoConnection = connection as AVCaptureConnection
					break
				}
			}
			if (videoConnection != nil) { break }
		}
		
		self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) { (buffer, error) in
			let img = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
			var url: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
			url = url.URLByAppendingPathComponent("image\(self.count).jpg")
			img.writeToURL(url, atomically: true)
			self.images.append(UIImage(data: img)!)
//			println("Added image")
//			println("\(self.images)")
			self.count++
//			println("Captured image")
		}
	}
	
	func updateUI() {
		leftImage.image = self.images[0]
//		rightImage.image = self.images[1]
	}
	
}