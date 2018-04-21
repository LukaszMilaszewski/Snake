import Foundation

protocol GameHandlerDelegate: class {
  func collision()
  func updateBoard(board: Board)
}

class GameHandler {
  var delegate: GameHandlerDelegate?
  var timer: Timer?
  var snake: Snake?
  var board: Board?
  var apple: Apple?
  
  init(boardWidth: Int, boardHeight: Int, snakeLength: Int) {
    board = Board(width: boardWidth, height: boardHeight)
    snake = Snake(length: snakeLength)
  }
  
  func startGame() {
    setInitialBoard()
    self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.timerMethod(_:)), userInfo: nil, repeats: true)
  }
  
  func setSnakeDirection(direction: Direction) {
    if snake!.isDirectionPossible(direction: direction) {
      snake!.direction = direction
    }
  }
  
  func setInitialBoard() {
    generateApple()
    board!.updateBoard(snake: snake!, apple: apple!)
    board!.printBoard()
    delegate?.updateBoard(board: board!)
  }
  
  func generateApple() {
    apple = Apple(boardWidth: board!.getWidth(), boardHeight: board!.getHeight())
  }
  
  func updateApple() {
    board!.removeApple(apple: apple!)
    generateApple()
  }
  
  func isAppleGained() -> Bool {
    return snake!.getHead() == apple ? true : false
  }
  
  @objc func timerMethod(_ timer:Timer) {
    snake!.makeMove()
    
    if board!.checkColision(snake: snake!) {
      timer.invalidate()
      delegate?.collision()

      return
    }
    
    if isAppleGained() {
      updateApple()
      snake!.isAppleGained = true
    }
    
    board!.updateBoard(snake: snake!, apple: apple!)
    delegate?.updateBoard(board: board!)
  }
}
