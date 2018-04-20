import UIKit

class Board {
  var scene = [[Int]]()
  let width:Int
  let height:Int
  
  init(width: Int = Constants.boardWidth, height: Int = Constants.boardHeight) {
    self.width = width
    self.height = height
    
    self.clearScene()
  }
  
  func printScene() {
    for i in 0..<scene.count {
      var line = ""
      for j in 0..<scene[i].count {
        line += String(scene[i][j])
        line += " "
      }
      print(line)
    }
  }
  
  func clearScene() {
    scene = [[Int]](repeating: [Int](repeating: 0, count: width), count: height)
  }
  
  func isWallCollision(snake: Snake) -> Bool {
    return snake.getHeadX() < 0 || snake.getHeadY() < 0 ? true : false
  }
  
  func checkColision(snake: Snake) -> Bool {
    return snake.isSelfCollision() || isWallCollision(snake: snake)
  }
  
  func updateScene(snake: Snake) {
    clearScene()
    for point in snake.body {
      scene[point.y][point.x] = 1
    }
  }
}
