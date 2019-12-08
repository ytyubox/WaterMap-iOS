//
//  URL+.swift
//  WaterMap
//
//  Created by 游宗諭 on 2019/12/8.
//  Copyright © 2019 游宗諭. All rights reserved.
//

import Foundation


extension URL: ExpressibleByStringInterpolation {
	public typealias StringLiteralType = String
	
	
	public init(stringLiteral value: Self.StringLiteralType) {
		self.init(string: value)!
	}
}
