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
        line += String(board[i][j]) + " "
      }
      print(line)
    }
  }
  
  func clearBoard() {
    board = [[Int]](repeating: [Int](repeating: 0, count: getWidth()), count: getHeight())
  }
  
  func setElement(x: Int, y: Int, value: Int) {
    board[y][x] = value
  }
}
