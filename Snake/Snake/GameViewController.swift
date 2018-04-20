import UIKit
class GameViewController: UIViewController {
  
  var timer:Timer?
  var snake = Snake(length: 5)
  var board = Board()
  
  func testMove(times: Int = 20) {
    for _ in 0..<times {
      snake.makeMove()
      board.updateScene(snake: snake)
      board.printScene()
      print("----")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    board.updateScene(snake: snake)
    board.printScene()
    print("----")
    testMove()
  }
}
