import UIKit

class Utils {
  static func getRandomPoint(xMax: Int, yMax: Int) -> Point {
    let x = Int(arc4random_uniform(UInt32(xMax)))
    let y = Int(arc4random_uniform(UInt32(yMax)))
    
    return Point(x: x, y: y)
  }
  
  static func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
    let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
    let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
    rotatedViewBox.transform = t
    let rotatedSize: CGSize = rotatedViewBox.frame.size
    UIGraphicsBeginImageContext(rotatedSize)
    let bitmap: CGContext = UIGraphicsGetCurrentContext()!
    bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
    bitmap.rotate(by: (degrees * CGFloat.pi / 180))
    bitmap.scaleBy(x: 1.0, y: -1.0)
    bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
  
  static func getItemColor(value: Int) -> CGColor? {
    switch value {
    case Item.nothing.rawValue:
      return UIColor.white.cgColor
    case Item.snake.rawValue:
      return UIColor(red: 249/255, green: 187/255, blue: 45/255, alpha: 1).cgColor
    case Item.apple.rawValue:
      return UIColor.red.cgColor
    default:
      return nil
    }
  }
}


