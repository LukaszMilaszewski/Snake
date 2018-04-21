import UIKit

class GameViewModel {
  var view: UIView
  var squares: [[CAShapeLayer]]?
  var offsetX: Int?
  var offsetY: Int?
  
  init(view: UIView, color: UIColor, width: Int, height: Int, offsetX: Int, offsetY: Int) {
    self.view = view
    self.offsetX = offsetX
    self.offsetY = offsetY
    view.backgroundColor = color
    squares = [[CAShapeLayer]](repeating: [CAShapeLayer](repeating: CAShapeLayer(), count: width),
                               count: height)
  }
  
  func temp(board: Board) {
    for i in 0..<board.getHeight() {
      for j in 0..<board.getWidth() {
        squares![i][j] = getLayer(x: offsetX! + j * Constants.squareDimension, y: offsetY! + i * Constants.squareDimension, value: board.getElement(x: i, y: j))
      }
    }
    view.layer.sublayers?.removeAll()
    for i in 0..<squares!.count {
      for j in 0..<squares![i].count {
        view.layer.addSublayer(squares![i][j])
      }
    }
  }
  
  func getLayer(x: Int, y: Int, value: Int) -> CAShapeLayer {
    let layer = CAShapeLayer()
    let element = CGRect(x: x, y: y, width: Constants.squareDimension, height: Constants.squareDimension)
    layer.path = UIBezierPath(roundedRect: element, cornerRadius: 4).cgPath
    
    switch value {
    case 0:
      layer.fillColor = UIColor.white.cgColor
    case 1:
      layer.fillColor = UIColor.black.cgColor
    case 5:
      layer.fillColor = UIColor.red.cgColor
    default:
      print("cannot happen")
    }
    
    return layer
  }
}
