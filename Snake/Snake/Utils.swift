import Foundation

class Utils {
  static func getRandomPoint(xMax: Int, yMax: Int) -> Point {
    let x = Int(arc4random_uniform(UInt32(xMax)))
    let y = Int(arc4random_uniform(UInt32(yMax)))
    
    return Point(x: x, y: y)
  }
}
