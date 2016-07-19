//
//  MSDynamicMenu.swift
//  MSDynamicMenu
//
//  Created by Midhun on 3/4/16.
//  Copyright © 2016 InApp. All rights reserved.
//

import Foundation
import UIKit

class MSDynamicMenu: UIView,UIDynamicAnimatorDelegate,UICollisionBehaviorDelegate {
    
    var animator : UIDynamicAnimator!
    var closeButtonAnimator:UIDynamicAnimator!
   
   var closeButton:UIButton!
    
    var gravityBehaviour: UIGravityBehavior!
    var dynamicItemBehaviour: UIDynamicItemBehavior!
    var collisionBehaviour:UICollisionBehavior!
    var attachmentBehaviour:UIAttachmentBehavior!
    
    var selected:Bool = false
    
    
    override init (frame : CGRect) {
        
        super.init(frame : frame)
        
        addBlurEffect()
        setupAnimators()
        addCloseButton()
    }

    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
   
    var items:[UIButton]?{
        
        didSet{
            
                updateInitialValues()
        }
       
    }
    
    
    func show(){
        
        let win:UIWindow = UIApplication.sharedApplication().delegate!.window!!
        win.addSubview(self)
    }
    
    
    func addBlurEffect(){
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            
            self.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            self.addSubview(blurEffectView)
        }
        else {
            
            self.backgroundColor = UIColor.blackColor()
        }

    }
    
    func addCloseButton(){
        
        closeButton = UIButton(frame: CGRectMake(self.frame.width-100, 0, 50, 50))
        closeButton.setImage(UIImage(named: "close"), forState: UIControlState.Normal)
        closeButton.addTarget(self, action: Selector("closeDidClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(closeButton)
        addBehavioursForCloseButton()
        
    }
    
    func setupAnimators(){
        
        animator = UIDynamicAnimator(referenceView: self)
        closeButtonAnimator = UIDynamicAnimator(referenceView: self)
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        
        print("added menu")
        
        let snapX : CGFloat = self.frame.width/2
        let snapY :CGFloat =  self.frame.height/4
        
        addSnapBehaviour(CGPointMake(snapX, snapY))
        addDynamicItemBehaviour()
    
        
    }
    
    func updateInitialValues(){
       
        let initialX : CGFloat = -100
        var initialY :CGFloat = self.frame.height/4
        let spaceBetween :CGFloat = 25
        
        for (index, element) in items!.enumerate(){
            
            element.center = CGPointMake(initialX, initialY)
            initialY += element.frame.height + spaceBetween;
            print("Item \(index): \(element.tag)")
            element.tag = index
            element.addTarget(self, action: Selector("buttonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
            addSubview(element)
        }
        
    }
    
   func addBehavioursForCloseButton(){
    
        let g = UIGravityBehavior(items: [self.closeButton])
      //  g.gravityDirection = CGVectorMake(-3,2)
        g.magnitude = 9.8
        self.closeButtonAnimator.addBehavior(g)
        let attachmentBehaviour =  UIAttachmentBehavior(item: closeButton, attachedToAnchor: CGPointMake(self.closeButton.center.x, 0))
        attachmentBehaviour.length = self.frame.height/8
        attachmentBehaviour.frequency = 3.0
        attachmentBehaviour.damping = 0.2
        self.closeButtonAnimator.addBehavior(attachmentBehaviour)

    }
    
    func addDynamicItemBehaviour(){
        
        dynamicItemBehaviour = UIDynamicItemBehavior(items: items!)
        dynamicItemBehaviour.allowsRotation = false
        dynamicItemBehaviour.elasticity = 0.5
        dynamicItemBehaviour.friction = 0.2
        dynamicItemBehaviour.density = 0.3
        
        self.animator.addBehavior(dynamicItemBehaviour)
    }
    
    func addSnapBehaviour(var destinationPoint:CGPoint){
        
        let spaceBetween :CGFloat = (CGFloat)(100 / (items!.count))

        var dampingValue : CGFloat = 0.5
        for (_, element) in items!.enumerate(){
            
            let snapBehaviour = UISnapBehavior(item: element, snapToPoint: destinationPoint)
            snapBehaviour.damping = dampingValue
            dampingValue -= 0.05
            destinationPoint.y += element.frame.height + spaceBetween;
            self.animator.addBehavior(snapBehaviour)
        }
        
    }
    
    func addGravityBehaviour(){
        
        self.gravityBehaviour = UIGravityBehavior(items: items!)
        self.gravityBehaviour.gravityDirection = CGVectorMake(0,2)
        self.gravityBehaviour.magnitude = 9.8
        self.animator.addBehavior(self.gravityBehaviour)
        
    }
    
    func addCollisionBehaviour(){
        
        collisionBehaviour = UICollisionBehavior(items: items!)
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = true
    //    collisionBehaviour.addBoundaryWithIdentifier("sideboundary", fromPoint: CGPointMake(0, self.frame.height), toPoint: CGPointMake(self.frame.width, self.frame.height))
        
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = true
        collisionBehaviour.collisionDelegate = self
        self.animator.addBehavior(collisionBehaviour)

    }
    

    
    func buttonClicked( sender:UIButton!){
     

        print("button clicked : \(sender.tag)")
        
        self.animator.removeAllBehaviors()
    
        addDynamicItemBehaviour()
        addGravityBehaviour()
        addCollisionBehaviour()
        
        
        let attach =    UIAttachmentBehavior(item: sender, attachedToAnchor: self.center)
        attach.length = 0
        attach.damping = 0.2
        attach.frequency = 3.0
       
        self.animator.addBehavior(attach)
        
        self.collisionBehaviour.removeItem(sender)
        self.dynamicItemBehaviour.allowsRotation = true

         for (_, element) in items!.enumerate(){
         
            if !element .isEqual(sender) {
            let push = UIPushBehavior(items: [element], mode: UIPushBehaviorMode.Instantaneous)

            push.angle = (CGFloat) ((-0.7 * M_PI)  + (Double) (arc4random()%25 / 10));
            push.magnitude = 1;
            self.animator.addBehavior(push)
            }
            
        }
      
        self.gravityBehaviour.action = {() in
            
        }

        selected = true
        
        sender.transform = CGAffineTransformMakeScale(2.0, 2.0)
        self.animator.updateItemUsingCurrentState(sender)
        
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("closeMenu"), userInfo: nil, repeats: false)
        
        
    }
  
    //MARK: ## Delegates
    
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        
        print("collision ended")

       
        
    }
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        
        print("collision began")
        
        
    }
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
     
        
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem) {
        
        
        
    }
    
    func closeDidClicked(){
        
        playReverseAction();
        
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            
            self.alpha = 0.0
            
            }) { (completed) -> Void in
                
                self.removeMenu()
        }

        
    }
    
    func playReverseAction(){
        
        self.closeButtonAnimator.removeAllBehaviors()
        self.animator.removeAllBehaviors()
        
        addSnapBehaviour(CGPointMake(-100, self.frame.height/4))
        
        let g = UIGravityBehavior(items: [self.closeButton])
        //   g.gravityDirection = CGVectorMake(0,)
        g.magnitude = -0.5
        self.closeButtonAnimator.addBehavior(g)
        let attachmentBehaviour =  UIAttachmentBehavior(item: closeButton, attachedToAnchor: CGPointMake(self.closeButton.center.x, self.closeButton.center.y))
        
        attachmentBehaviour.length = 300
        attachmentBehaviour.frequency = 2.0
        attachmentBehaviour.damping = 0.4
        self.closeButtonAnimator.addBehavior(attachmentBehaviour)
        
    }
    
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        
        
        self .removeFromSuperview()

        
    }
    
    func  closeMenu(){
        
        playReverseAction()
  
         UIView.animateWithDuration(0.8, animations: { () -> Void in
            
            self.alpha = 0.0
            
            }) { (completed) -> Void in
                
                self.removeMenu()
        }
    }

    
    
    
    func removeMenu(){
        
        self.removeFromSuperview()
    }
    
}
