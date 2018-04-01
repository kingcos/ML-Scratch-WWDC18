//
//  Created by kingcos on 29/03/2018.
//  Copyright © 2018 kingcos. All rights reserved.
//

import UIKit

protocol DrawHandwritingProtocol {
    var lineColor: UIColor { get set }
    var forceCoefficient: CGFloat { get set }
    
    func drawHandwriting(_ touch: UITouch)
    func clear()
    func lineWidth(_ touch: UITouch) -> CGFloat
}

protocol DrawRectsProtocol {
    var handwritingRectMinX: CGFloat { get }
    var handwritingRectMinY: CGFloat { get }
    var handwritingRectMaxX: CGFloat { get }
    var handwritingRectMaxY: CGFloat { get }
    
    var edgeInset: CGFloat { get }
    
    var rectBorderColor: UIColor { get }
    var handwritingRect: CGRect { get }
    
    func initDrawRects()
    func drawRect()
}

@objc(CanvasView)
public class CanvasView: UIImageView, DrawHandwritingProtocol, DrawRectsProtocol {
    
    var context: CGContext?
    var touchEndedTimeInterval: TimeInterval = 0.0
    var cropImageRect: CGRect?
    weak var delegate: ViewController?
    
    // DrawHandwritingProtocol
    var lineColor: UIColor = .black
    var forceCoefficient: CGFloat = 5.0
    
    // DrawRectsProtocol
    var handwritingRectMinX: CGFloat = 0.0
    var handwritingRectMinY: CGFloat = 0.0
    var handwritingRectMaxX: CGFloat = 0.0
    var handwritingRectMaxY: CGFloat = 0.0
    var edgeInset: CGFloat = 10.0
    
    var handwritingRect: CGRect {
        return CGRect(x: handwritingRectMinX - edgeInset,
                      y: handwritingRectMinY - edgeInset,
                      width: handwritingRectMaxX - handwritingRectMinX + 2 * edgeInset,
                      height: handwritingRectMaxY - handwritingRectMinY + 2 * edgeInset)
    }
    
    var rectBorderColor: UIColor = UIColor.black
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
        clipsToBounds = true
    }
    
    // Called when user moved touches
    override public func touchesMoved(_ touches: Set<UITouch>,
                                      with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if touchEndedTimeInterval == 0 {
            clear()
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        context = UIGraphicsGetCurrentContext()
        
        touchEndedTimeInterval = Date().timeIntervalSince1970
        
        image?.draw(in: bounds)

        if let coalescedTouches = event?.coalescedTouches(for: touch) {
            for touch in coalescedTouches {
                drawHandwriting(touch)
            }
        } else {
            drawHandwriting(touch)
        }

        // Draw predicted touches (Not good)
//        if let predictedTouches = event?.predictedTouches(for: touch) {
//            _ = predictedTouches.map {
//                drawHandwriting($0)
//            }
//        }

        image = UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func setup() {
        initDrawRects()
        
        Timer.scheduledTimer(withTimeInterval: 0.5,
                             repeats: true) { _ in
                                let currentTimeInterval = Date().timeIntervalSince1970
                                if (self.touchEndedTimeInterval > 0)
                                && (currentTimeInterval - self.touchEndedTimeInterval > 0.5) {
                                    self.drawRect()
                                    Brain.detect(CIImage(image: (self.image?.crop(self.cropImageRect))!)) { result in
                                        DispatchQueue.main.async {
                                            self.delegate?.resultLabel.text = result
                                        }
                                    }
                                    // Control by UISwitch
//                                    Helper.saveToAlumn(self.image?.crop(self.cropImageRect))
                                }
        }
    }
}

extension CanvasView {
    func lineWidth(_ touch: UITouch) -> CGFloat {
        var lineWidth: CGFloat = 5.0
        
        if touch.type == .stylus {
            if touch.force > 0 {
                lineWidth = touch.force * forceCoefficient
            }
        } else {
            if touch.majorRadius > 3.0 {
                lineWidth = touch.majorRadius / 3.0
            }
        }
        
        return lineWidth
    }
    
    func clear() {
        UIView.animate(withDuration: 0.5) {
            self.image = nil
        }
    }
    
    func drawHandwriting(_ touch: UITouch) {
        let preLocation = touch.previousLocation(in: self)
        let curLocation = touch.location(in: self)
        
        handwritingRectMinX = min(handwritingRectMinX, curLocation.x)
        handwritingRectMinY = min(handwritingRectMinY, curLocation.y)
        handwritingRectMaxX = max(handwritingRectMaxX, curLocation.x)
        handwritingRectMaxY = max(handwritingRectMaxY, curLocation.y)
        
        context?.setStrokeColor(lineColor.cgColor)
        context?.setLineWidth(lineWidth(touch))
        context?.setLineCap(.round)
        context?.move(to: preLocation)
        context?.addLine(to: curLocation)
        context?.strokePath()
    }
}

extension CanvasView {
    func initDrawRects() {
        handwritingRectMinX = frame.width
        handwritingRectMinY = frame.height
        handwritingRectMaxX = 0.0
        handwritingRectMaxY = 0.0
        
        touchEndedTimeInterval = 0.0
    }
    
    func drawRect() {
        cropImageRect = CGRect(x: handwritingRect.origin.x + 1.0,
                               y: handwritingRect.origin.y + 1.0,
                               width: handwritingRect.size.width - 2.0,
                               height: handwritingRect.size.height - 2.0)
        
        context?.setStrokeColor(rectBorderColor.cgColor)
        context?.setLineWidth(1.0)
        context?.setLineCap(.round)
        context?.setFillColor(UIColor.clear.cgColor)
        
        context?.addRect(handwritingRect)
        context?.strokePath()
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        initDrawRects()
    }
}
