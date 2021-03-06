import UIKit

protocol GameViewModelDelegate: class {
  func restartButtonPressed()
  func backButtonPressed()
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
  
  init(view: UIView, color: UIColor, board: Board, snake: Snake, apple: Apple, showGrid: Bool) {
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
    if showGrid {
      addGridLayer()
    }
    addSnakeLayer(points: snake.body, name: Constants.snakeLayerName)
    addAppleLayer(apple: apple)
  }
  
  func addGridLayer() {
    let layer = CAShapeLayer()
    
    let path = UIBezierPath()
    path.lineWidth = CGFloat(Constants.gridWidth)
    for index in 1..<width {
      let start = CGPoint(x: index * Constants.squareDimension + offsetX, y: offsetY)
      let end = CGPoint(x: index * Constants.squareDimension + offsetX,
                        y: height * Constants.squareDimension + offsetY)
      path.move(to: start)
      path.addLine(to: end)
    }
    
    for index in 1..<height {
      let start = CGPoint(x: offsetX, y: index * Constants.squareDimension + offsetY)
      let end = CGPoint(x: width * Constants.squareDimension + offsetX,
                        y: index * Constants.squareDimension + offsetY)
      path.move(to: start)
      path.addLine(to: end)
    }
    path.close()
    
    layer.path = path.cgPath
    layer.name = Constants.gridLayerName
    layer.strokeColor = UIColor.black.cgColor
    
    view.layer.addSublayer(layer)
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
    layer.contents = Constants.appleImage.cgImage
    layer.contentsGravity = kCAGravityResize
    layer.masksToBounds = false
    layer.add(scaleAnimation(), forKey: Constants.scaleAnimationKeyPath)

    return layer
  }
  
  func createLayer(x: Int, y: Int, itemValue: Int,
                   width: Int = Constants.squareDimension,
                   height: Int = Constants.squareDimension,
                   cornerRadius: Int = Constants.squareDimension / 2) -> CALayer {
    let layer = CALayer()
    layer.cornerRadius = CGFloat(cornerRadius)
    let layerRect = CGRect(x: x, y: y, width: width, height: height)
    layer.frame = layerRect
    layer.backgroundColor = Utils.getItemColor(value: itemValue)

    return layer
  }
  
  func updateSnake(snake: Snake) {
    let snakeLayerIndex = getLayerIndex(layerName: Constants.snakeLayerName)
    var animateSnake = false
    
    if snake.shouldGrow {
      animateSnake = !animateSnake
    }
    
    let newSnakeLayer = CALayer()
    newSnakeLayer.name = Constants.snakeLayerName
    
    for (index, point) in snake.body.reversed().enumerated() {
      let layer = createLayer(x: offsetX + point.x * Constants.squareDimension,
                              y: offsetY + point.y * Constants.squareDimension,
                              itemValue: Item.snake.rawValue)
      if index == 0 {
        layer.backgroundColor = Utils.getItemColor(value: Item.nothing.rawValue)
        var snakeHead = Constants.snakeHeadImage
        switch snake.direction {
        case .down:
          break
        case .up:
          snakeHead = Utils.imageRotatedByDegrees(oldImage: snakeHead, deg: 180)
        case .left:
          snakeHead = Utils.imageRotatedByDegrees(oldImage: snakeHead, deg: 90)
        case .right:
          snakeHead = Utils.imageRotatedByDegrees(oldImage: snakeHead, deg: 270)
        }
        layer.contents = snakeHead.cgImage
      }
      
      if animateSnake {
        layer.add(scaleAnimation(from: 1.0, to: 1.4, duration: 0.2, repeatCount: 1), forKey: Constants.scaleAnimationKeyPath)
      }
      newSnakeLayer.addSublayer(layer)
    }
    view.layer.sublayers![snakeLayerIndex!] = newSnakeLayer
  }
  
  func getLayerIndex(layerName: String) -> Int? {
    for (index, layer) in view.layer.sublayers!.enumerated() {
      if layer.name == layerName {
        return index
      }
    }
    return nil
  }
  
  func updateApple(apple: Apple) {
    let layer = createAppleLayer(apple: apple)
    let appleLayerIndex = getLayerIndex(layerName: Constants.appleLayerName)
    view.layer.sublayers![appleLayerIndex!] = layer
  }
  
  func updateObstacles(obstacles: [Point]) {
    let obstaclesLayer = CALayer()
    for point in obstacles {
      let layer = createLayer(x: offsetX + point.x * Constants.squareDimension,
                              y: offsetY + point.y * Constants.squareDimension,
                              itemValue: Item.obstacle.rawValue)
      obstaclesLayer.addSublayer(layer)
    }
    
    if let obstaclesLayerIndex = getLayerIndex(layerName: Constants.obstaclesLayerName) {
      view.layer.sublayers![obstaclesLayerIndex] = obstaclesLayer
    } else {
      obstaclesLayer.name = Constants.obstaclesLayerName
      view.layer.addSublayer(obstaclesLayer)
    }
  }
  
  func showAlert(score: Int) {
    let alert = UIAlertController(title: "GAME OVER!", message: "Your score \(score).", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
      self.delegate?.restartButtonPressed()
    }))
    alert.addAction(UIAlertAction(title: "Back to menu", style: .cancel, handler: { _ in
      self.delegate?.backButtonPressed()
    }))
    delegate?.presentAlert(alert: alert)
  }
}
