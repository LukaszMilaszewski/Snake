import UIKit

protocol GameViewModelDelegate: class {
  func restartButtonPressed()
  func presentAlert(alert: UIAlertController)
}

class GameViewModel {
  private var view: UIView
  private var color: UIColor
  
  private var width: Int
  private var height: Int
  private var offsetX: Int
  private var offsetY: Int
  
  var delegate: GameViewModelDelegate?
  
  init(view: UIView, color: UIColor, board: Board, snake: Snake, apple: Apple) {
    self.view = view
    self.color = color
    view.backgroundColor = color
    let screenWidth = Int(view.bounds.width)
    let screenHeight = Int(view.bounds.height)
    
    width = Int(screenWidth / Constants.squareDimension)
    height = Int(screenHeight / Constants.squareDimension)
    
    offsetX = (screenWidth - width * Constants.squareDimension) / 2
    offsetY = (screenHeight - height * Constants.squareDimension) / 2
    
    addBoardLayer(width: board.width, height: board.height, name: Constants.boardLayerName)
    addSnakeLayer(points: snake.body, name: Constants.snakeLayerName)
    addAppleLayer(apple: apple)
  }
  
  func addBoardLayer(width: Int, height: Int, name: String) {
    let boardLayer = createLayer(x: offsetX, y: offsetY, itemValue: Item.nothing.rawValue,
                             width: width * Constants.squareDimension,
                             height: height * Constants.squareDimension)
    boardLayer.name = name
    view.layer.addSublayer(boardLayer)
  }
  
  private func scaleAnimation(from: Double = 1.0, to: Double = 0.8, duration: Double = 0.8,
                              repeatCount: Float = Float.infinity) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "transform.scale")
    animation.fromValue = from
    animation.toValue = to
    animation.duration = duration
    animation.autoreverses = true
    animation.repeatCount = repeatCount
    
    return animation
  }
  
  func addSnakeLayer(points: [Point], name: String) {
    let snakeLayer = CALayer()
    snakeLayer.name = name
    
    for point in points {
      let layer = createLayer(x: offsetX + point.x * Constants.squareDimension,
                              y: offsetY + point.y * Constants.squareDimension,
                              itemValue: Item.snake.rawValue)
      snakeLayer.addSublayer(layer)
    }
    view.layer.addSublayer(snakeLayer)
  }
  
  func addAppleLayer(apple: Apple) {
    let layer = createAppleLayer(apple: apple)
    view.layer.addSublayer(layer)
  }
  
  func createAppleLayer(apple: Apple) -> CALayer {
    let layer = createLayer(x: offsetX + apple.x * Constants.squareDimension,
                            y: offsetY + apple.y * Constants.squareDimension,
                            itemValue: Item.nothing.rawValue)
    layer.name = Constants.appleLayerName
    layer.contents = apple.image.cgImage
    layer.contentsGravity = kCAGravityResize
    layer.masksToBounds = false
    layer.add(scaleAnimation(), forKey: Constants.scaleAnimationKeyPath)

    return layer
  }
  
  func createLayer(x: Int, y: Int, itemValue: Int,
                   width: Int = Constants.squareDimension,
                   height: Int = Constants.squareDimension ) -> CALayer {
    let layer = CALayer()
    let layerRect = CGRect(x: x, y: y, width: width, height: height)
    layer.frame = layerRect
    layer.backgroundColor = getItemColor(value: itemValue)

    return layer
  }
  
  func getItemColor(value: Int) -> CGColor? {
    switch value {
    case Item.nothing.rawValue:
      return UIColor.white.cgColor
    case Item.snake.rawValue:
      return UIColor.black.cgColor
    case Item.apple.rawValue:
      return UIColor.red.cgColor
    default:
      return nil
    }
  }
  
  func updateSnake(snake: Snake) {
    let snakeLayerIndex = getLayerIndex(layerName: Constants.snakeLayerName)
    var animateSnake = false
    
    if snake.shouldGrow {
      animateSnake = !animateSnake
    }
    
    let newSnakeLayer = CALayer()
    newSnakeLayer.name = Constants.snakeLayerName
    
    for point in snake.body.reversed() {
      let layer = createLayer(x: offsetX + point.x * Constants.squareDimension,
                              y: offsetY + point.y * Constants.squareDimension,
                              itemValue: Item.snake.rawValue)
      if animateSnake {
        layer.add(scaleAnimation(from: 1.0, to: 1.4, duration: 0.2, repeatCount: 1), forKey: Constants.scaleAnimationKeyPath)
      }
      newSnakeLayer.addSublayer(layer)
    }
    view.layer.sublayers![snakeLayerIndex] = newSnakeLayer
  }
  
  func getLayerIndex(layerName: String) -> Int {
    for (index, layer) in view.layer.sublayers!.enumerated() {
      if layer.name == layerName {
        return index
      }
    }
    //TODO: handle index out of bounds
    return 10
  }
  
  func updateApple(apple: Apple) {
    let layer = createAppleLayer(apple: apple)
    let appleLayerIndex = getLayerIndex(layerName: Constants.appleLayerName)
    view.layer.sublayers![appleLayerIndex] = layer
  }
  
  func showAlert(score: Int) {
    let alert = UIAlertController(title: "GAME OVER!", message: "Your score \(score).", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
      self.delegate?.restartButtonPressed()
    }))
    delegate?.presentAlert(alert: alert)
  }
}
