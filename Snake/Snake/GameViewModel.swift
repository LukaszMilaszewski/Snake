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
    
    createBoardView(board: board)
    createSnakeView(snake: snake)
    createAppleView(apple: apple)
  }
  
  func createBoardView(board: Board) {
    boardLayer = CAShapeLayer()
    for i in 0..<board.board.count {
      for j in 0..<board.board[i].count {
        let layer = getLayer(x: offsetX + j * Constants.squareDimension, y: offsetY + i * Constants.squareDimension)
        layer.setColor(value: Item.nothing.rawValue)
        boardLayer?.addSublayer(layer)
      }
    }
    view.layer.addSublayer(boardLayer!)
  }
  
  func createAppleView(apple: Apple) {
    let layer = getLayer(x: offsetX + apple.x * Constants.squareDimension, y: offsetY + apple.y * Constants.squareDimension)
    layer.setColor(value: Item.apple.rawValue)
    view.layer.addSublayer(layer)
  }
  
  func createSnakeView(snake: Snake) {
    snakeLayer = CAShapeLayer()
    
    for point in snake.body {
      let layer = getLayer(x: offsetX + point.x * Constants.squareDimension,
                           y: offsetY + point.y * Constants.squareDimension)
      
      layer.setColor(value: Item.snake.rawValue)
      snakeLayer?.addSublayer(layer)
    }
    view.layer.addSublayer(snakeLayer!)
  }
  
  func updateApple(apple: Apple) {
    let layer = getLayer(x: offsetX + apple.x * Constants.squareDimension, y: offsetY + apple.y * Constants.squareDimension)
    layer.setColor(value: Item.apple.rawValue)
    view.layer.sublayers![2] = layer
  }
  
  func showView(snake: Snake, apple: Apple) {
    
    let blabla = view.layer.sublayers![1]
    if blabla.sublayers?.count == snake.body.count {
      updateApple(apple: apple)
    }
    
    let temp = CAShapeLayer()
    for point in snake.body {
      let layer = getLayer(x: offsetX + point.x * Constants.squareDimension,
                           y: offsetY + point.y * Constants.squareDimension)
      layer.setColor(value: Item.snake.rawValue)
      temp.addSublayer(layer)
    }
    view.layer.sublayers![1] = temp
    
  }

  
  func getLayer(x: Int, y: Int) -> CAShapeLayer {
    let layer = CAShapeLayer()
    let element = CGRect(x: x, y: y, width: Constants.squareDimension, height: Constants.squareDimension)
    layer.path = UIBezierPath(roundedRect: element, cornerRadius: 4).cgPath

    return layer
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
