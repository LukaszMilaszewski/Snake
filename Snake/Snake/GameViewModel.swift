import UIKit

protocol GameViewModelDelegate: class {
  func restartButtonPressed()
  func presentAlert(alert: UIAlertController)
}

class GameViewModel {
  var view: UIView
  var squares: [[CAShapeLayer]]

  var width: Int
  var height: Int
  var offsetX: Int
  var offsetY: Int
  
  var delegate: GameViewModelDelegate?
  
  init(view: UIView, color: UIColor) {
    self.view = view
    let screenWidth = Int(view.bounds.width)
    let screenHeight = Int(view.bounds.height)
    
    width = Int(screenWidth / Constants.squareDimension)
    height = Int(screenHeight / Constants.squareDimension)
    
    offsetX = (screenWidth - width * Constants.squareDimension) / 2
    offsetY = (screenHeight - height * Constants.squareDimension) / 2
    
    view.backgroundColor = color
    squares = [[CAShapeLayer]](repeating: [CAShapeLayer](repeating: CAShapeLayer(), count: width),
                               count: height)
  }
  
  func showView(board: Board) {
    for i in 0..<board.getHeight() {
      for j in 0..<board.getWidth() {
        squares[i][j] = getLayer(x: offsetX + j * Constants.squareDimension,
                                 y: offsetY + i * Constants.squareDimension,
                                 value: board.getElement(x: i, y: j))
      }
    }
    view.layer.sublayers?.removeAll()
    for i in 0..<squares.count {
      for j in 0..<squares[i].count {
        view.layer.addSublayer(squares[i][j])
      }
    }
  }
  
  func getLayer(x: Int, y: Int, value: Int) -> CAShapeLayer {
    let layer = CAShapeLayer()
    let element = CGRect(x: x, y: y, width: Constants.squareDimension, height: Constants.squareDimension)
    layer.path = UIBezierPath(roundedRect: element, cornerRadius: 4).cgPath
    
    switch value {
    case Item.nothing.rawValue:
      layer.fillColor = UIColor.white.cgColor
    case Item.snake.rawValue:
      layer.fillColor = UIColor.black.cgColor
    case Item.apple.rawValue:
      layer.fillColor = UIColor.red.cgColor
    default:
      print("cannot happen")
    }
    
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
