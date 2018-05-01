import UIKit

class Apple: Point {
  var image: UIImage
  var xMax: Int
  var yMax: Int
  
  init(xMax: Int, yMax: Int, image: UIImage = Constants.appleImagePath) {
    self.xMax = xMax
    self.yMax = yMax
    self.image = image
    
    let randomPoint = Utils.getRandomPoint(xMax: xMax, yMax: yMax)
    super.init(x:randomPoint.x, y: randomPoint.y)
  }
  
  func setPosition(point: Point) {
    x = point.x
    y = point.y
  }
  
  func setRandomPosition() {
    let point = Utils.getRandomPoint(xMax: xMax, yMax: yMax)
    setPosition(point: point)
  }
  
  func changeMaxes(xMax: Int, yMax: Int) {
    self.xMax = xMax
    self.yMax = yMax
  }
}
