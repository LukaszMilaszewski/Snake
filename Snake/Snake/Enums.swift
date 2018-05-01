enum Direction {
  case up
  case down
  case right
  case left
}

enum Speed: Double {
  case slow = 0.7
  case medium = 0.5
  case fast = 0.3
}

enum Item: Int {
  case nothing = 0
  case snake = 1
  case apple = 2
}
