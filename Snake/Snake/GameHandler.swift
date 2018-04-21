import Foundation

protocol GameHandlerDelegate: class {
  func collision()
  func updatedBoard(board: Board)
}

class GameHandler {
 
  var delegate: GameHandlerDelegate?
  var timer:Timer?
  var snake = Snake()
  var board = Board()
  var apple: Apple?
  
  init() {
    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerMethod(_:)), userInfo: nil, repeats: true)
    setInitialBoard()
  }
  
  func setSnakeDirection(direction: Direction) {
    snake.direction = direction
  }
  
  func setInitialBoard() {
    generateApple()
    board.updateBoard(snake: snake, apple: apple!)
    board.printBoard()
  }
  
  func generateApple() {
    apple = Apple(boardWidth: board.width, boardHeight: board.height)
  }
  
  func updateApple() {
    board.removeApple(apple: apple!)
    generateApple()
  }
  
  func isAppleGained() -> Bool {
    return snake.getHead() == apple ? true : false
  }
  
  @objc func timerMethod(_ timer:Timer) {
    snake.makeMove()
    
    if board.checkColision(snake: snake) {
      timer.invalidate()
      delegate?.collision()
      
      return
    }
    
    if isAppleGained() {
      updateApple()
      snake.isAppleGained = true
    }
    
    board.updateBoard(snake: snake, apple: apple!)
    delegate?.updatedBoard(board: board)
  }
}
