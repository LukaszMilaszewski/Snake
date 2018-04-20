import Foundation

class Apple: Point {
  let imagePath: String
  
  init(boardWidth: Int, boardHeight: Int, imagePath: String = Constants.appleImagePath) {
    let x = Int(arc4random_uniform(UInt32(boardWidth)))
    let y = Int(arc4random_uniform(UInt32(boardHeight)))
    self.imagePath = imagePath
    
    super.init(x: x, y: y)
    
  }
}
