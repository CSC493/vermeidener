//
//  Matrix.swift
//  Image Test
//
//  Created by Christopher Primerano on 2015-02-18.
//  Copyright (c) 2015 Christopher Primerano. All rights reserved.
//

import Foundation

struct Matrix {
	
	let rows: Int, columns: Int
	var grid: [Double]
	
	init(rows: Int, columns: Int) {
		self.rows = rows
		self.columns = columns
		self.grid = Array(count: rows * columns, repeatedValue: 0.0)
	}
	
	func indexIsValidForRow(row: Int, column: Int) -> Bool {
		return row >= 0 && row < rows && column >= 0 && column < columns
	}
	
	subscript(row: Int, column: Int) -> Double {
		get {
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			return grid[(row * columns) + column]
		}
		set {
			assert(indexIsValidForRow(row, column: column), "Index out of range")
			grid[(row * columns) + column] = newValue
		}
	}
	
	func determinant() -> Double? {
		if self.rows != self.columns {
			return nil
		}
		
		var total: Double = 0
		var add: Bool = true
		
		for x in 0..<self.columns {
			var subMatrix: Matrix = Matrix(rows: self.rows - 1, columns: self.columns - 1)
			for y in 1..<self.rows {
				for i in 0..<self.columns {
					if i != x {
						let temp = i > x ? i - 1 : i
						subMatrix[y, temp] = self[y, i]
					}
				}
			}
			if add {
				total += self[0, x] * subMatrix.determinant()!
				add = !add
			} else {
				total -= self[0, x] * subMatrix.determinant()!
				add = !add
			}
		}
		return total
	}
	
}
