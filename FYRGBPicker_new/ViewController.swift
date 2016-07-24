//
//  ViewController.swift
//  FYRGBPicker_new
//
//  Created by FumikoYamamoto on 2016/07/24.
//  Copyright © 2016年 FumikoYamamoto. All rights reserved.
//

import UIKit


extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
        
    }
}


extension UIColor {
    
    var floatValues: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = -1, g:CGFloat = -1, b:CGFloat = -1, a:CGFloat = -1
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var myImageView :UIImageView!
    var myImage :UIImage!
    
    @IBOutlet weak var rLabel :UILabel?
    @IBOutlet weak var gLabel :UILabel?
    @IBOutlet weak var bLabel :UILabel?
    @IBOutlet weak var aLabel :UILabel?


    override func viewDidLoad() {
        super.viewDidLoad()
        myImage = UIImage(named:"red.jpg")
        myImageView.image = myImage
        
        getPixleOfImage()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPixleOfImage(){
        
        let width = Int(myImage.size.width)
        let height = Int(myImage.size.height)
//        let imageData:NSData! = UIImagePNGRepresentation(myImage)  //uiimageをnsdataに変換
        
        var imageBytes : UnsafeMutablePointer<Int8>  //画像が何byteかを格納する入れ物
        let newByteLength = width * height * 4  //1pxは4byte,画像が何byteか
        imageBytes = UnsafeMutablePointer<Int8>.alloc(newByteLength)  //imageBytesにnewByteLengthをalloc
        
        for x in 0..<width {  //幅が0より大きいときまで回す
            for y in 0..<height {  //縦が0より大きいときまだ回す
                
                let point = CGPoint(x: x, y: y)  //画像の中の点をとる
                var colorOfImage = myImage.getPixelColor(point) //UIColorを格納
                
                let red: CGFloat = colorOfImage.floatValues.red
                let green: CGFloat = colorOfImage.floatValues.green
                let blue: CGFloat = colorOfImage.floatValues.blue
                let alpha: CGFloat = colorOfImage.floatValues.alpha
                
                rLabel?.text = String(red)
                gLabel?.text = String(green)
                bLabel?.text = String(blue)
                aLabel?.text = String(alpha)
                
                //redっていう配列に各pixleの値を格納、それらの中から取る(forで回してiを足してく、newByteLengthまで？/4かな多分)
                
                if red > 0.0 {
                    //赤だと判断したら、下敷きと同じ色にする
                    colorOfImage = UIColor.clearColor()
                }
            }
        }
    }
}