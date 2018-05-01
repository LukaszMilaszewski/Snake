import UIKit

class Constants {
  static let snakeLength = 4
  static let snakeDirection = Direction.down
  
  static let appleImagePath = #imageLiteral(resourceName: "apple")
  
  static let squareDimension = 20
  static let backgroundColor = UIColor.gray
  
  static let initialGameSpeed = Speed.fast
  
  static let boardLayerName = "BoardLayer"
  static let snakeLayerName = "SnakeLayer"
  static let appleLayerName = "AppleLayer"
  static let scaleAnimationKeyPath = "scaleAnimation"
}
