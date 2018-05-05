import UIKit

class Constants {
  static let snakeLength = 4
  static let snakeDirection = Direction.down
  
  static let appleImage = #imageLiteral(resourceName: "apple")
  static let snakeHeadImage = #imageLiteral(resourceName: "snake_head")
  
  static let squareDimension = 30
  static let backgroundColor = UIColor.gray
  static let gridWidth = 2.0
  
  static let initialGameSpeed = 0.4
  static let increaseSpeedStep = 0.1
  static let scorePointsToIncreaseSpeed = 5
  
  static let scorePointsToAddObstacle = 2
  
  static let boardLayerName = "BoardLayer"
  static let snakeLayerName = "SnakeLayer"
  static let appleLayerName = "AppleLayer"
  static let gridLayerName = "GridLayer"
  static let obstaclesLayerName = "ObstaclesLayer"
  
  static let scaleAnimationKeyPath = "scaleAnimation"
}
