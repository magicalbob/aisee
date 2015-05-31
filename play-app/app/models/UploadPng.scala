package models

import play.Play
import play.api.libs.Files
import play.api.mvc._

object UploadPng {

  def uploadPng(tempFile: Option[MultipartFormData.FilePart[Files.TemporaryFile]]): String = {
    tempFile.map { fileToUpload =>
      import java.io.File
      val fileName = fileToUpload.filename
      fileToUpload.contentType match {
        case Some(contentType) if contentType == "image/png" =>
          fileToUpload.ref.moveTo(new File(Play.application.path.getPath +
            Play.application.configuration.getString("upload.directory") + fileName))
          "SUCCESS"
        case _ => "FAIL"
      }
    }.getOrElse {
      "FAIL"
    }
  }

}
