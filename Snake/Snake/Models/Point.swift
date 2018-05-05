class Point {
  var x: Int
  var y: Int
  
  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

extension Point: Equatable {
  static func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
  }
  
  static func ==(lhs: Point, rhs: [Point]) -> Bool {
    for point in rhs {
      if lhs == point {
        return true
      }
    }
    return false
  }
}
