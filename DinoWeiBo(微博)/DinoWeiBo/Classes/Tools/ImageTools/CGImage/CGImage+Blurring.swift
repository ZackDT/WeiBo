// CGImage+Blurring.swift
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
import Accelerate


private let _gaussianblur_kernel_5x5: [Int16] = [
	1, 4, 6, 4, 1,
	4, 16, 24, 16, 4,
	6, 24, 36, 24, 6,
	4, 16, 24, 16, 4,
	1, 4, 6, 4, 1
]


public extension CGImage
{
	public func gaussianBlurred(_ bias: Int32 = 0) -> CGImage?
	{
		// Create an ARGB bitmap context
		let width = self.width
		let height = self.height
		guard let bmContext = CGContext.ARGBBitmapContext(width: width, height: height, withAlpha: self.hasAlpha()) else
		{
			return nil
		}

		bmContext.draw(self, in: CGRect(0, 0, width, height))

		guard let data = bmContext.data else
		{
			return nil
		}

		let bytesPerRow = width * numberOfComponentsPerARBGPixel
		let size = MemoryLayout<UInt8>.size * width * height * 4
		let bufferOut = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
		var src = vImage_Buffer(data: data, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
		var dst = vImage_Buffer(data: bufferOut, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
		vImageConvolveWithBias_ARGB8888(&src, &dst, nil, 0, 0, _gaussianblur_kernel_5x5, 5, 5, 256/*divisor*/, bias, nil, vImage_Flags(kvImageCopyInPlace))

		// Cleanup
		data.copyBytes(from: bufferOut, count: size)
		bufferOut.deallocate(capacity: size)

		return bmContext.makeImage()
	}
}
