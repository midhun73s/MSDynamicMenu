//
//  ViewController.swift
//  MSDynamicMenu
//
//  Created by Midhun on 3/4/16.
//  Copyright © 2016 InApp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func menuDidClicked(sender: AnyObject) {
        
        let menu:MSDynamicMenu = MSDynamicMenu(frame: self.view.frame)
        
        let button1 : UIButton = UIButton(frame: CGRectMake(0, 150, 50, 50))
     //   button1.backgroundColor = UIColor.greenColor()
       button1.setImage(UIImage(named: "fb"), forState: UIControlState.Normal)
        
        
        let button2 : UIButton = UIButton(frame: CGRectMake(0, 250, 50, 50))
         button2.setImage(UIImage(named: "google+"), forState: UIControlState.Normal)
      
        let button3 : UIButton = UIButton(frame: CGRectMake(0, 350, 50, 50))
        button3.setImage(UIImage(named: "twitter"), forState: UIControlState.Normal)
        
        let button4 : UIButton = UIButton(frame: CGRectMake(0, 350, 50, 50))
        button4.setImage(UIImage(named: "linkdin"), forState: UIControlState.Normal)
        
        let button5 : UIButton = UIButton(frame: CGRectMake(0, 350, 50, 50))
        button5.setImage(UIImage(named: "messenger"), forState: UIControlState.Normal)
        
        menu.items = [button1,button2,button3,button4,button5]
    
        menu.show()
      
    
    //    self.view.addSubview(menu)
    }

}

