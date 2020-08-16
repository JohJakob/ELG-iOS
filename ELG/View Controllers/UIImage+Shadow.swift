//
//  UIImage+Shadow.swift
//  ELG
//
//  Created by Johannes Jakob on 28/07/2017
//  © Brian Coyner, Elisabeth-Gymnasium Halle, Johannes Jakob
//

import Foundation
import UIKit
import CoreGraphics

public struct Shadow {
	let color: UIColor
	let offset: CGSize
	let blur: CGFloat
	
	public init(color: UIColor, offset: CGSize, blur: CGFloat) {
		self.color = color
		self.offset = offset
		self.blur = blur
	}
}

extension UIImage {
	public static func resizableShadowImage(
		withSideLength sideLength: CGFloat,
		cornerRadius: CGFloat,
		shadow: Shadow,
		shouldDrawCapInsets: Bool = false
	) -> UIImage {
		let lengthAdjustment = sideLength + (shadow.blur * 2)
		let graphicsContextSize = CGSize(width: lengthAdjustment, height: lengthAdjustment)
		
		UIGraphicsBeginImageContextWithOptions(graphicsContextSize, false, UIScreen.main.scale)
		
		let context = UIGraphicsGetCurrentContext()!
		
		defer {
			UIGraphicsEndImageContext()
		}
		
		let roundedRect = CGRect(x: shadow.blur, y: shadow.blur, width: sideLength, height: sideLength)
		let shadowPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: cornerRadius)
		
		context.saveGState()
		context.addRect(context.boundingBoxOfClipPath)
		context.addPath(shadowPath.cgPath)
		context.clip(using: .evenOdd)
		
		let color = shadow.color.cgColor
		
		context.setStrokeColor(color)
		context.addPath(shadowPath.cgPath)
		context.setShadow(offset: shadow.offset, blur: shadow.blur, color: color)
		context.fillPath()
		context.restoreGState()
		
		let capInset = cornerRadius + shadow.blur
		
		if shouldDrawCapInsets {
			let debugRect = CGRect(origin: CGPoint(x: 0, y: 0), size: graphicsContextSize)
			
			context.setStrokeColor(UIColor.purple.cgColor)
			context.beginPath()
			
			// Top line
			
			context.move(to: CGPoint(x: debugRect.origin.x, y: debugRect.origin.y + capInset))
			context.addLine(to: CGPoint(x: debugRect.size.width + capInset, y: debugRect.origin.y + capInset))
			
			// Bottom line
			
			context.move(to: CGPoint(x: debugRect.origin.x, y: debugRect.size.height - capInset))
			context.addLine(to: CGPoint(x: debugRect.size.width + capInset, y: debugRect.size.height - capInset))
			
			// Left line
			
			context.move(to: CGPoint(x: debugRect.origin.x + capInset, y: debugRect.origin.y))
			context.addLine(to: CGPoint(x: debugRect.origin.x + capInset, y: debugRect.size.height))
			
			// Right line
			
			context.move(to: CGPoint(x: debugRect.size.width - capInset, y: debugRect.origin.y))
			context.addLine(to: CGPoint(x: debugRect.size.width - capInset, y: debugRect.size.height))
			
			context.strokePath()
			
			context.addRect(debugRect.insetBy(dx: 0.5, dy: 0.5))
			context.setStrokeColor(UIColor.red.cgColor)
			context.strokePath()
		}
		
		let image = UIGraphicsGetImageFromCurrentImageContext()!
		let edgeInsets = UIEdgeInsets(top: capInset, left: capInset, bottom: capInset, right: capInset)
		
		return image.resizableImage(withCapInsets: edgeInsets, resizingMode: .tile)
	}
}
