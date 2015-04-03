//
//  CMExtensions.swift
//  Image Test
//
//  Created by Christopher Primerano on 2015-02-08.
//  Copyright (c) 2015 Christopher Primerano. All rights reserved.
//

import Foundation
import CoreMotion


extension CMQuaternion: Printable {
	public var description: String {
		get {
			return "x: \(self.x), y: \(self.y), z: \(self.z), w: \(self.w)"
		}
	}
}

extension CMQuaternion {
	var vector: Vector {
		get {
			return Vector(member: self.x / sin(self.theta / 2), self.y / sin(self.theta / 2), self.z / sin(self.theta / 2))
		}
	}
	
	public var theta: Double {
		get {
			return acos(self.w) * 2
		}
	}
	
	public var length: Double {
		return self.vector.length
	}
	
	public func multiply(q2: CMQuaternion) -> CMQuaternion {
		let v1 = self.vector
		let v2 = q2.vector
		
		let w = (self.w * q2.w) - v1 • v2
		let v = (self.w * v2) + (q2.w * v1) + v1 × v2
		
		return CMQuaternion(x: x, y: y, z: z, w: w)
	}
}


extension CMAcceleration: Printable {
	public var description: String {
		get {
			return "x: \(self.x), y: \(self.y), z: \(self.z)"
		}
	}
}

extension CMAcceleration {
	func displacement(accel: CMAcceleration, time: Double) -> Vector {
		let sub = Vector(member: self.x, self.y, self.z) - Vector(member: accel.x, accel.y, accel.z)
		let mult = pow(time, 2) * sub
		let div = mult / 2
		return div
	}
}

extension CMRotationRate: Printable {
	public var description: String {
		get {
			return "x: \(self.x), y: \(self.y), z: \(self.z)"
		}
	}
}


extension CMRotationMatrix: Printable {
	public var description: String {
		get {
			return "[\(self.m11), \(self.m12), \(self.m13)]\n[\(self.m21), \(self.m22), \(self.m23)]\n[\(self.m31), \(self.m32), \(self.m33)]"
		}
	}
}


extension CMDeviceMotion: Printable {
	override public var description: String {
		get {
			return "timestamp = \(self.timestamp)\ngravity = \(self.gravity)\nuserAcceleration = \(self.userAcceleration)\nattitude = \(self.attitude.quaternion)\nattitudeV&T = Vector: \(self.attitude.quaternion.vector), Theta: \(self.attitude.quaternion.theta)\nattitudeRM = \n\(self.attitude.rotationMatrix)\nrotationRate = \(self.rotationRate)\n"
		}
	}
}