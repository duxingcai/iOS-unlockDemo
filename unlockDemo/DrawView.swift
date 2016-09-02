//
//  DrawView.swift
//  unlockDemo
//
//  Created by 杜杜兴 on 15/10/11.
//  Copyright © 2015年 杜杜兴. All rights reserved.
//

import UIKit
//声明一个协议
@objc protocol drawViewDelegate{
    //传递路径
    func lockViewDidFinish(drawV:DrawView,path:NSString)
}
class DrawView: UIView {
     //设置代理
    @IBOutlet weak var lockDelegate:(drawViewDelegate)!
    var btnSelectArr:(NSMutableArray)=[]  //用来保存获取到的按钮集合
    //storyboard,XIB关联，必须实现此方法
    required init?(coder aDecoder:NSCoder){
        super.init(coder:aDecoder)
         //接收通知
NSNotificationCenter.defaultCenter().addObserver(self,selector:"cleanBtns",name:"whClean",object:nil)
        //加载
        createButton()
    }
    
    //清空按钮，并重绘
    func cleanBtns(){
       self.btnSelectArr.removeAllObjects()
        self.setNeedsDisplay()
    }
    //自定义方法：创建九宫格
    func createButton(){
        var secret=0
        for row in 0...2{
            for col in 0...2{
                let buttonDistance=100 //间距
                let firseBtnPointX=44  //第一个按钮的X值
                let firstBtnPointY=24   //第一个按钮的Y值
                let tempX:(CGFloat)=CGFloat(firseBtnPointX+col*buttonDistance)
                let tempY:(CGFloat)=CGFloat(firstBtnPointY+row*buttonDistance)
                //声明按钮
                let btn:(UIButton)=UIButton(type:UIButtonType.Custom)
                btn.userInteractionEnabled=false //关闭用户交互
                btn.frame=CGRectMake(tempX, tempY, 100, 100)
                //默认
                btn.setImage(UIImage(named: "gesture_node_normal@2x.png"),forState: UIControlState.Normal)
                //选中
                btn.setImage(UIImage(named: "gesture_node_highlighted"), forState: UIControlState.Selected)
                //用来当做密码
                btn.tag=secret++
                //添加
                self.addSubview(btn)
            }
        }
    }
    
    //抽代码，返回获取到的触摸点
    func pointWithTouches(touches:NSSet)->CGPoint{
        //触摸点
        let touch:AnyObject?=touches.anyObject()//任意对象
        //获取位置
        let pos:(CGPoint)=touch!.locationInView(touch!.view)
        return pos
    }
    
    //抽代码:获取可触摸到的按钮
    func buttonWithPoint(point:CGPoint)->UIButton?{
        //遍历当前View的子视图
        for btn in self.subviews{
            if CGRectContainsPoint(btn.frame, point){
                 //表示触摸的点在按钮上
                return btn as? UIButton
            }
        }
        return nil
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let pos:(CGPoint)=self.pointWithTouches(touches)
        //获取可触摸到的按钮
        let btn:(UIButton)?=self.buttonWithPoint(pos)
        if self.btnSelectArr.containsObject(btn!)==false{
            //表示触摸到的按钮并没有在集合中
            btn!.selected=true//让按钮选中
            //加载到可变数组
            self.btnSelectArr.addObject(btn!)
        }
        //刷新
        self.setNeedsDisplay()
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let pos:(CGPoint)=self.pointWithTouches(touches)
        let btn:(UIButton)?=self.buttonWithPoint(pos)
        //按钮按钮未被选中，并且按钮不为空
        if(btn != nil)&&(btn?.selected==false){
            btn!.selected=true//按钮选中
            //触摸移动过程中选中的按钮加入数组
            self.btnSelectArr.addObject(btn!)
        }
        //刷新
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) { //判断有无代理
        if lockDelegate != nil{
            let str:(NSMutableString)=NSMutableString()
            if self.btnSelectArr.count>0{
                //遍历
                for index in 0...btnSelectArr.count-1{
                    let btn:(UIButton)=self.btnSelectArr.objectAtIndex(index) as! UIButton
                    //把按钮的tag值连接到可变字符串
                    str.appendFormat("%d", btn.tag)
                }
                if str.length>0{
                    //发送消息
                    lockDelegate.lockViewDidFinish(self, path: str)
                }
            }
        }

        //把选中的按钮设为默认状态
        if self.btnSelectArr.count>0{
              //遍历数组
            for index in 0...self.btnSelectArr.count-1{
                let btn:(UIButton)=self.btnSelectArr.objectAtIndex(index) as! UIButton
                btn.selected=false                
            }
        }
        //清空数组
        self.btnSelectArr.removeAllObjects()
        //界面重绘
        self.setNeedsDisplay()
           }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        //有没有按钮
       if self.btnSelectArr.count==0{
            return //没有选中按钮直接返回
        }
        //有按钮，则绘制
        let path:(UIBezierPath)=UIBezierPath()//创建路径
        for index in 0...self.btnSelectArr.count-1{
            let btn:(UIButton)=self.btnSelectArr.objectAtIndex(index) as! (UIButton)
            //第一个按钮（每次绘制的起点）
            if index==0{
              path.moveToPoint(btn.center)
            }else{
                path.addLineToPoint(btn.center)//链接
            }
        }
        path.lineWidth=8//线宽
        
       // UIColor().blueColor().set()//连线颜色
        path.stroke()//绘制
    }
}

















