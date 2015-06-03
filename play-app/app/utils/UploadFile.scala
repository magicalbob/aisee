package utils

import play.Play
import play.api.libs.Files
import play.api.mvc._

object UploadFile extends UploadUtility {

  def upload(tempFile: Option[MultipartFormData.FilePart[Files.TemporaryFile]]): String = {
    tempFile.map { fileToUpload =>
      import java.io.File
      val fileName = "input." + fileToUpload.filename.split("\\.").last
      allowedContentTypes.contains(fileToUpload.contentType.getOrElse("")) match {
        case true =>
          fileToUpload.ref.moveTo(new File(Play.application.path.getPath +
            Play.application.configuration.getString("upload.directory") + fileName), true)
          "SUCCESS"
        case _ => "INVALID_CONTENT_TYPE"
      }
    }.getOrElse {
      "FAIL"
    }
  }

}