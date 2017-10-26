// CGPoint+Extensions.swift
// Copyright (c) 2016 Nyx0uf
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import CoreGraphics


public extension CGPoint
{
	// MARK: - Initializers
	public init(_ x: CGFloat, _ y: CGFloat)
	{
		self.x = x
		self.y = y
	}

	public init(_ x: Int, _ y: Int)
	{
		self.x = CGFloat(x)
		self.y = CGFloat(y)
	}

	public func ceilled() -> CGPoint
	{
		return CGPoint(CoreGraphics.ceil(x), CoreGraphics.ceil(y))
	}

	public func floored() -> CGPoint
	{
		return CGPoint(CoreGraphics.floor(x), CoreGraphics.floor(y))
	}

	public func rounded() -> CGPoint
	{
		return CGPoint(CoreGraphics.round(x), CoreGraphics.round(y))
	}
}
