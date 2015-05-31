package utils

import play.Play
import play.api.libs.Files
import play.api.mvc._

object UploadPng extends UploadUtility {

  def uploadPng(tempFile: Option[MultipartFormData.FilePart[Files.TemporaryFile]]): String = {
    tempFile.map { fileToUpload =>
      import java.io.File
      val fileName = fileToUpload.filename
      allowedContentTypes.contains(fileToUpload.contentType.getOrElse("")) match {
        case true =>
          fileToUpload.ref.moveTo(new File(Play.application.path.getPath +
            Play.application.configuration.getString("upload.directory") + fileName))
          "SUCCESS"
        case _ => "INVALID_CONTENT_TYPE"
      }
    }.getOrElse {
      "FAIL"
    }
  }

}
