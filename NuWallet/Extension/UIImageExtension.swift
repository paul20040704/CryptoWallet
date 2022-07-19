//
//  UIImageExtension.swift
//  NuWallet
//
//  Created by paul.chen-mini on 2022/6/6.
//

import Foundation
import UIKit


extension UIImage {
    // 修复图片旋转
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
         
        var transform = CGAffineTransform.identity
         
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
             
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
             
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
             
        default:
            break
        }
         
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
             
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
             
        default:
            break
        }
         
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
         
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
             
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
         
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
         
        return img
    }
    
    //壓縮圖片
    func resizeImage() -> UIImage{

            //prepare constants
            let width = self.size.width
            let height = self.size.height
            let scale = width/height
            
            var sizeChange = CGSize()
            
            if width <= 1280 && height <= 1280{ //a，圖片寬或者高均小於或等於1280時圖片尺寸保持不變，不改變圖片大小
                return self
            }else if width > 1280 || height > 1280 {//b,寬或者高大於1280，但是圖片寬度高度比小於或等於2，則將圖片寬或者高取大的等比壓縮至1280
                
                if scale <= 2 && scale >= 1 {
                    let changedWidth:CGFloat = 1280
                    let changedheight:CGFloat = changedWidth / scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                
                }else if scale >= 0.5 && scale <= 1 {
                    
                    let changedheight:CGFloat = 1280
                    let changedWidth:CGFloat = changedheight * scale
                    sizeChange = CGSize(width: changedWidth, height: changedheight)
                    
                }else if width > 1280 && height > 1280 {//寬以及高均大於1280，但是圖片寬高比大於2時，則寬或者高取小的等比壓縮至1280
                    
                    if scale > 2 {//高的值比較小
                        
                        let changedheight:CGFloat = 1280
                        let changedWidth:CGFloat = changedheight * scale
                        sizeChange = CGSize(width: changedWidth, height: changedheight)
                        
                    }else if scale < 0.5{//寬的值比較小
                        
                        let changedWidth:CGFloat = 1280
                        let changedheight:CGFloat = changedWidth / scale
                        sizeChange = CGSize(width: changedWidth, height: changedheight)
                        
                    }
                }else {//d, 寬或者高，只有一個大於1280，並且寬高比超過2，不改變圖片大小
                    return self
                }
            }

            UIGraphicsBeginImageContext(sizeChange)
            
            //draw resized image on Context
            self.draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))

            //create UIImage
            let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return resizedImg ?? self
            
        }
    
    
    
    
}
