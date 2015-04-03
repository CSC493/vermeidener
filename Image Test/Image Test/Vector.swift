//
//  NewVector.swift
//  Image Test
//
//  Created by Christopher Primerano on 2015-02-18.
//  Copyright (c) 2015 Christopher Primerano. All rights reserved.
//

import Foundation


public struct Vector: Equatable {
	private var members: Array<Double> = [Double]()
	
	public init(member: Double...) {
		self.members = member
	}
	
	public var length: Double {
		var total: Double = 0
		for member in self.members {
			total += pow(member, 2)
		}
		return sqrt(total)
	}
	
	public mutating func append(member: Double) {
		self.members.append(member)
	}
	
	public func get(index: Int) -> Double {
		return self.members[index]
	}
	
	public mutating func insert(member: Double, index: Int) {
		self.members.insert(member, atIndex: index)
	}
	
	public var count: Int {
		return self.members.count
	}
	
}


extension Vector: Printable {
	public var description: String {
		var desc = ""
		for member in self.members {
			desc += "\(member), "
		}
		return desc
	}
}

extension Vector {
	subscript (index: Int) -> Double {
		get {
			return self.members[index]
		}
		set(member) {
			self.members[index] = member
		}
	}
}




prefix func - (v: Vector) -> Vector {
	return -1 * v
}

func + (left: Vector, right: Vector) -> Vector {
	var newv: Vector = Vector()
	for index in 0..<left.count {
		newv.append(left[index] + right[index])
	}
	return newv
}

func += (inout left: Vector, right: Vector) {
	left = left + right
}

func * (s: Double, v: Vector) -> Vector {
	var newv: Vector = Vector()
	for member in v.members {
		newv.append(member * s)
	}
	return newv
}

func * (v: Vector, s: Double) -> Vector {
	return s * v
}

func *= (inout v: Vector, s: Double) {
	v = s * v
}

func / (v: Vector, s: Double) -> Vector {
	var newv: Vector = Vector()
	for member in v.members {
		newv.append(member / s)
	}
	return newv
}

func /= (inout v: Vector, s: Double) {
	v = v / s
}

func - (left: Vector, right: Vector) -> Vector {
	return left + -right
}

func -= (inout left: Vector, right: Vector) {
	left = left - right
}

public func == (left: Vector, right: Vector) -> Bool {
	var equal: Bool = true
	for index in 0..<left.count {
		if left[index] != right[index] {
			equal = false
			break
		}
	}
	return equal
}

infix operator • { associativity left precedence 150 }

func • (left: Vector, right: Vector) -> Double {
	var total: Double = 0
	for index in 0..<left.count {
		total += left[index] * right[index]
	}
	return total
}

infix operator × { associativity left precedence 150 }

func × (left: Vector, right: Vector) -> Vector {
	var output: Vector = Vector()
	
	var add: Bool = true
	
	
	
	for x in 0..<left.count {
		var subMatrix: Matrix = Matrix(rows: left.count - 1, columns: left.count - 1)
		for i in 0..<left.count {
			if i != x {
				let temp = i > x ? i - 1 : i
				subMatrix[0, temp] = left[i]
			}
		}
		for i in 0..<left.count {
			if i != x {
				let temp = i > x ? i - 1 : i
				subMatrix[1, temp] = right[i]
			}
		}
		if add {
			output.append(subMatrix.determinant()!)
			add = !add
		} else {
			output.append(-1 * subMatrix.determinant()!)
			add = !add
		}
	}
	
	return output
}

infix operator ×= { associativity right precedence 90 }

func ×= (inout left: Vector, right: Vector) {
	left = left × right
}