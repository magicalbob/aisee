package ai

object Image {
  val width = 16
  val height = 16

  def pixelOutOfBounds(x: Int, y: Int): Boolean = {
    (x < 0) || (y < 0) || (x > width - 1) || (y > height - 1)
  }
}
