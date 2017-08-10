//
//  Joypad.swift
//  Petrone
//
//  Created by Byrobot on 2017. 7. 18..
//  Copyright © 2017년 Byrobot. All rights reserved.
//

import UIKit

public class Joypad : UIView, UIGestureRecognizerDelegate {
    weak open var delegate: JoypadProtocol?
    private var imageThum : UIImageView?
    private var centerPosition : CGPoint = CGPoint()
    private var startPosition : CGPoint = CGPoint()
    
    var isPlay : Bool = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        startPosition = CGPoint(x: frame.origin.x + frame.size.width/2, y: frame.origin.y +  frame.size.height/2)
        centerPosition = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
    }
    
    public convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
        centerPosition = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
    }
    
    override public func draw(_ rect: CGRect)
    {
        // create circle.
        drawRingFittingInsideView()
        
        // Create pan gesture.
        let panSelf : UIPanGestureRecognizer = UIPanGestureRecognizer(target:self, action:#selector(Joypad.padControl(sender:)))
        panSelf.delegate = self
        
        self.addGestureRecognizer(panSelf)
        
        // Create thum image.
        self.imageThum = UIImageView(image: circle(diameter: 16.0, color: UIColor.white))
        
        self.imageThum?.center = centerPosition
        self.addSubview(imageThum!)
    }
    
    internal func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width:diameter, height:diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.saveGState()
        
        let rect = CGRect(x:0, y:0, width:diameter, height:diameter)
        ctx!.setFillColor(color.cgColor)
        ctx!.fillEllipse(in: rect)
        ctx!.restoreGState()
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    internal func drawRingFittingInsideView()->()
    {
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - 2 ),
            startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        
        layer.addSublayer(shapeLayer)
    }
    
    func onStart() {
        isPlay = true
    }
    
    func onStop() {
        isPlay = false
        imageThum!.center = self.center
    }
    
    func setImages(thum: UIImage) {
        if( imageThum != nil ) {
            imageThum?.image = thum
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch? = touches.first
        var localPostion = touch?.location(in: self.superview)
        
        localPostion = CGPoint( x: max( self.frame.size.width/2, min((self.superview?.frame.size.width)!-self.frame.size.width/2, (localPostion?.x)!)), y:max( self.frame.size.height/2, min((self.superview?.frame.size.height)!-self.frame.size.height/2, (localPostion?.y)!)))
        
        self.center = localPostion!
        
        self.next?.touchesBegan(touches, with: event)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        imageThum!.center = centerPosition
        self.center = startPosition
        self.next?.touchesEnded(touches, with: event)
        
        if self.delegate != nil {
            self.delegate?.control(self, update: CGPoint.zero)
        }
    }
    
    @objc public func joypadCenter(center: CGPoint) {
        self.centerPosition = center
    }
    
    @objc public func padControl( sender : UIPanGestureRecognizer ) {
        if( !isPlay ) {
            return
        }
        
        if( sender.state == UIGestureRecognizerState.ended ) {
            imageThum!.center = centerPosition
            self.center = startPosition
            if self.delegate != nil {
                self.delegate?.control(self, update: CGPoint.zero)
            }
        } else {
            var localPostion = sender.location(in: self)
            
            localPostion = CGPoint( x: max( 0, min(self.frame.size.width, localPostion.x)), y:max( 0, min(self.frame.size.height, localPostion.y)))
            imageThum!.center = localPostion //CGPoint( x: self.center.x + localPostion.x, y: self.center.y + localPostion.y )
            
            if self.delegate != nil {
                self.delegate?.control(self, update: CGPoint( x:localPostion.x-centerPosition.x, y:centerPosition.y - localPostion.y))
            }
        }
    }
}
