package ai

import play.Play
import java.io.{FileInputStream, File}
import com.sksamuel.scrimage._

object ImageOnRetina {

  val retinaDirectory = new File(Play.application.path.getPath +
    Play.application.configuration.getString("upload.directory"))
  val arrayOfFiles = retinaDirectory.listFiles.filter(_.getName.startsWith("input"))
  val imageFile = if (arrayOfFiles(0).exists) arrayOfFiles(0) else new File(retinaDirectory + "default.png")

  val rgb = withInputStream{ inputStream =>
    Image(inputStream).rgb
  }

  val width = 16
  val height = 16

  def pixelOutOfBounds(x: Int, y: Int): Boolean = {
    (x < 0) || (y < 0) || (x > width - 1) || (y > height - 1)
  }

  def withInputStream[A](f: (FileInputStream) => A): A = {
    val inputStream = new FileInputStream(imageFile)
    val rgb = f(inputStream)
    inputStream.close()
    rgb
  }

}
