enum Direction {
  case up
  case down
  case right
  case left
}

enum Speed: Double {
  case slow = 20
  case medium = 21
  case fast = 22
}

enum Item: Int {
  case nothing = 0
  case snake = 1
  case apple = 2
}
