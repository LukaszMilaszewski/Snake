class Board {
  var  board: [[Int]]

  init(width: Int, height: Int) {
    
    board = [[Int]](repeating: [Int](repeating: 0, count: width), count: height)
    clearBoard()
  }
  
  func getHeight() -> Int {
    return board.count
  }
  
  func getWidth() -> Int {
    return board[0].count
  }
  
  func getElement(x: Int, y: Int) -> Int {
    return board[x][y]
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
    board = [[Int]](repeating: [Int](repeating: 0, count: getWidth()), count: getHeight())
  }
  
  func isWallCollision(snake: Snake) -> Bool {
    let x = snake.getHeadX()
    let y = snake.getHeadY()
    
    return x < 0 || x >= getWidth() || y < 0 || y >= getHeight() ? true : false
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
