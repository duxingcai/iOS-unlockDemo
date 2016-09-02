//
//  ViewController.swift
//  unlockDemo
//
//  Created by 杜杜兴 on 15/10/11.
//  Copyright © 2015年 杜杜兴. All rights reserved.
//

import UIKit
     //在swift必须关联XIB,需要开发人员手动设置
let _drawVC=DrawViewController(nibName:"DrawViewController",bundle:nil)

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func btnClick(sender: UIButton) {
      //发送通知，清空按钮
NSNotificationCenter.defaultCenter().addObserver(self,selector:"cleanBtns",name:"whClean",object:nil)
        
        switch sender.tag{
        case 100://设置密码
            _drawVC.whTag=100
            break
        case 101://验证密码
            _drawVC.whTag=101
            break
        case 102://修改密码
            _drawVC.whTag=102
            break
        default:
            break
        }
    self.presentViewController(_drawVC,animated:true,completion:nil)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

