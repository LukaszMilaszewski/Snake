import UIKit

protocol GameViewModelDelegate: class {
  func restartButtonPressed()
  func presentAlert(alert: UIAlertController)
}

class GameViewModel {
  var view: UIView
  var color: UIColor
  
  var boardLayer: CAShapeLayer?
  var snakeLayer: CAShapeLayer?
  var appleLayer: CAShapeLayer?

  var width: Int
  var height: Int
  var offsetX: Int
  var offsetY: Int
  
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
    for i in 0..<board.board.count {
      for j in 0..<board.board[i].count {
        let layer = createLayer(x: offsetX + j * Constants.squareDimension,
                                y: offsetY + i * Constants.squareDimension,
                                itemValue: Item.nothing.rawValue)
        boardLayer?.addSublayer(layer)
      }
    }
    view.layer.addSublayer(boardLayer!)
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
    appleLayer?.addSublayer(layer)
    view.layer.addSublayer(appleLayer!)
  }
  
  func createLayer(x: Int, y: Int, itemValue: Int) -> CAShapeLayer {
    let layer = CAShapeLayer()
    let element = CGRect(x: x, y: y, width: Constants.squareDimension, height: Constants.squareDimension)
    layer.path = UIBezierPath(roundedRect: element, cornerRadius: 4).cgPath
    layer.setColor(value: itemValue)
    
    return layer
  }
  
  func showView(snake: Snake, apple: Apple) {
    let snakeLayerIndex = getLayerIndex(layerName: Constants.snakeLayerName)
    let snakeLayer = view.layer.sublayers![snakeLayerIndex]
   
    if snakeLayer.sublayers?.count == snake.body.count {
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
