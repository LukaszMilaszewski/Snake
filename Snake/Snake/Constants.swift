import UIKit

class Constants {
  static let snakeLength = 4
  static let snakeDirection = Direction.down
  
  static let appleImage = #imageLiteral(resourceName: "apple")
  static let snakeHeadImage = #imageLiteral(resourceName: "snake_head")
  
  static let squareDimension = 30
  static let backgroundColor = UIColor.gray
  
  static let initialGameSpeed = Speed.fast
  
  static let boardLayerName = "BoardLayer"
  static let snakeLayerName = "SnakeLayer"
  static let appleLayerName = "AppleLayer"
  static let scaleAnimationKeyPath = "scaleAnimation"
}
