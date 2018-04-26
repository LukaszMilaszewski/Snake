import UIKit

protocol GameViewModelDelegate: class {
  func restartButtonPressed()
  func presentAlert(alert: UIAlertController)
}

class GameViewModel {
  private var view: UIView
  private var color: UIColor
  
  private var boardLayer: CAShapeLayer?
  private var snakeLayer: CAShapeLayer?
  private var appleLayer: CAShapeLayer?

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
    
    boardLayer = createLayer(name: Constants.boardLayerName)
    appleLayer = createLayer(name: Constants.appleLayerName)
    snakeLayer = createLayer(name: Constants.snakeLayerName)
    
    addBoardLayer(board: board)
    addSnakeLayer(snake: snake)
    addAppleLayer(apple: apple)
  }
  
  func createLayer(name: String) -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.name = name
    
    return layer
  }
  
  func addBoardLayer(board: Board) {
    boardLayer = createLayer(x: offsetX, y: offsetY, itemValue: Item.nothing.rawValue,
                             width: board.width * Constants.squareDimension,
                             height: board.height * Constants.squareDimension)

    view.layer.addSublayer(boardLayer!)
  }
  
  private func scaleAnimation() -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "transform.scale")
    animation.fromValue = 1
    animation.toValue = 0.1
    animation.duration = 1.0
    animation.autoreverses = true
    animation.repeatCount = .infinity
    
    return animation
  }
  
  func addSnakeLayer(snake: Snake) {
    for point in snake.body {
      let layer = createLayer(x: offsetX + point.x * Constants.squareDimension,
                              y: offsetY + point.y * Constants.squareDimension,
                              itemValue: Item.snake.rawValue)
      snakeLayer?.addSublayer(layer)
    }
    view.layer.addSublayer(snakeLayer!)
    
  }
  
  func addAppleLayer(apple: Apple) {
    
    let layer = createLayer(x: offsetX + apple.x * Constants.squareDimension,
                            y: offsetY + apple.y * Constants.squareDimension,
                            itemValue: Item.apple.rawValue)
    print(layer.preferredFrameSize())
    print(layer.bounds)
    print(layer.frame)
    appleLayer?.addSublayer(layer)
    appleLayer?.add(scaleAnimation(), forKey: Constants.scaleAnimationKeyPath)
    
    view.layer.addSublayer(appleLayer!)

  }
  
  func createLayer(x: Int, y: Int, itemValue: Int,
                   width: Int = Constants.squareDimension,
                   height: Int = Constants.squareDimension ) -> CAShapeLayer {
    let layer = CAShapeLayer()
    let element = CGRect(x: x, y: y, width: width, height: height)

    layer.path = UIBezierPath(roundedRect: element, cornerRadius: 4).cgPath
    layer.setColor(value: itemValue)

    
    return layer
  }
  
  func showView(snake: Snake, apple: Apple) {
    let snakeLayerIndex = getLayerIndex(layerName: Constants.snakeLayerName)
    let snakeLayer = view.layer.sublayers![snakeLayerIndex]
   
    if snakeLayer.sublayers?.count != snake.getBodyLength() {
      updateApple(apple: apple)
    }
    
    let newSnakeLayer = createLayer(name: Constants.snakeLayerName)
    
    for point in snake.body {
      let layer = createLayer(x: offsetX + point.x * Constants.squareDimension,
                              y: offsetY + point.y * Constants.squareDimension,
                              itemValue: Item.snake.rawValue)
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
    print("temp")
    let layer = createLayer(x: offsetX + apple.x * Constants.squareDimension,
                            y: offsetY + apple.y * Constants.squareDimension,
                            itemValue: Item.apple.rawValue)
    layer.name = Constants.appleLayerName
    let appleLayerIndex = getLayerIndex(layerName: Constants.appleLayerName)
    view.layer.sublayers![appleLayerIndex] = layer
  }
  
  func showAlert() {
    let alert = UIAlertController(title: "GAME OVER!", message: "Game Over.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
      self.delegate?.restartButtonPressed()
    }))
    delegate?.presentAlert(alert: alert)
  }
}

extension CAShapeLayer {
  func setColor(value: Int) {
    switch value {
    case Item.nothing.rawValue:
      self.fillColor = UIColor.white.cgColor
    case Item.snake.rawValue:
      self.fillColor = UIColor.black.cgColor
    case Item.apple.rawValue:
      self.fillColor = UIColor.red.cgColor
    default:
    print("cannot happen")
    }
  }
}
