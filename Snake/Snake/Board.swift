class Board {
  var  board = [[Int]]()
  let width:Int
  let height:Int
  
  init(width: Int = Constants.boardWidth, height: Int = Constants.boardHeight) {
    self.width = width
    self.height = height
    
    self.clearBoard()
  }
  
  func printBoard() {
    for i in 0..<board.count {
      var line = ""
      for j in 0..<board[i].count {
        line += String(board[i][j])
        line += " "
      }
      print(line)
    }
  }
  
  func clearBoard() {
    board = [[Int]](repeating: [Int](repeating: 0, count: width), count: height)
  }
  
  func isWallCollision(snake: Snake) -> Bool {
    let x = snake.getHeadX()
    let y = snake.getHeadY()
    
    return x < 0 || x >= width || y < 0 || y >= height ? true : false
  }
  
  func checkColision(snake: Snake) -> Bool {
    return snake.isSelfCollision() || isWallCollision(snake: snake)
  }
  
  func addSnake(snake: Snake) {
    for point in snake.body {
      board[point.y][point.x] = 1
    }
  }
  
  func addApple(apple: Apple) {
    board[apple.y][apple.x] = 5
  }
  
  func removeApple(apple: Apple) {
    board[apple.y][apple.x] = 0
  }
  
  func updateBoard(snake: Snake, apple: Apple) {
    clearBoard()
    addApple(apple: apple)
    addSnake(snake: snake)
  }
}
