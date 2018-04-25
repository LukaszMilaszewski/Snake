class Board {
  var board: [[Int]]
  var empty: Int
  
  init(width: Int, height: Int, emptyItem: Item = Item.nothing) {
    empty = emptyItem.rawValue
    board = [[Int]](repeating: [Int](repeating: empty, count: width), count: height)
    clearBoard()
  }
  
  func clearBoard() {
    board = [[Int]](repeating: [Int](repeating: empty, count: getWidth()), count: getHeight())
  }
  
  func setElement(x: Int, y: Int, item: Item) {
    let value = item.rawValue
    board[y][x] = value
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
}
