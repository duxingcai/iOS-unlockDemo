//
//  DrawViewController.swift
//  unlockDemo
//
//  Created by 杜杜兴 on 15/10/11.
//  Copyright © 2015年 杜杜兴. All rights reserved.
//

import UIKit
//采用协议！
class DrawViewController: UIViewController,drawViewDelegate{
    //根据Tag值进行不同加载
    var whTag=0
    //标题属性
    @IBOutlet weak var titleLabel: UILabel!
    //每次触摸后的反馈,动态显示绘制密码后结果
    @IBOutlet weak var resultLabel: UILabel!
    //忘记密码执行的方法
    @IBAction func forgotSecret(sender: UIButton) {
        //返回主视图
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated:Bool){
        switch whTag{
        case 100://设置密码
            titleLabel.text="设置密码"
            resultLabel.text="请滑动设置新密码"
            //每次先清空原密码
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "wh")
            break
        case 101://验证密码
            titleLabel.text="验证密码"
            resultLabel.text="请滑动输入密码"
            break
        case 102://修改密码
            titleLabel.text="修改密码"
            resultLabel.text="请输入旧密码"
            break
        default:
            break
        }
         
    }
    
    //为实现协议
    func lockViewDidFinish(drawV: DrawView, path: NSString) {
        if path.length<4{
            resultLabel.text="请至少连接四个点"
            //提示文字的颜色
            resultLabel.textColor=UIColor.redColor()
        }
        else{
            var updateTag=0//修改时会用到
        if NSUserDefaults.standardUserDefaults().objectForKey("wh")==nil{
                resultLabel.text="请输入刚才的密码"
                resultLabel.textColor=UIColor.orangeColor()
              //存入
              NSUserDefaults.standardUserDefaults().setObject(path, forKey: "wh")
            }
        else if(NSUserDefaults.standardUserDefaults().objectForKey("wh")?.isEqual(path) != true){
            resultLabel.textColor=UIColor.redColor()
            if whTag==100{
                resultLabel.text="密码不一致,请重新输入"
            }
            else if whTag==101{
                resultLabel.text="验证失败!"
            }
            else if whTag==102{
                resultLabel.text="密码不一致"
            }
            else{
                if updateTag==0{
                    resultLabel.text="旧密码输入错误!"
                }
                else{
                    resultLabel.text="密码不一致,请重新输入新密码"
                }
            }
        }
            else
        {
           //两次密码一致
            resultLabel.textColor=UIColor.orangeColor()
            if whTag==100{
               resultLabel.text="密码设置成功!"
                //自动返回主菜单
                NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "forgotSecret", userInfo: nil, repeats: false)
            }
            else if whTag==101{
            resultLabel.text="密码验证成功"
                //自动返回主菜单
                NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "forgotSecret", userInfo: nil, repeats: false)
            }
            else{
                if updateTag==0{
                resultLabel.text="旧密码输入正确，请滑动输入新密码"
                //修改tag值
                updateTag=1
                //把这次绘制的路径写入文件
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "wh")
                }
                else{
                   resultLabel.text="新密码设置成功!"
                    //自动返回主菜单
             NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "forgotSecret", userInfo: nil, repeats: false)
                }
            }
        }
    }
        
 }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
