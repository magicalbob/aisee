package controllers

import play.api.mvc._
import utils.UploadFile
import ai.Brain

object Upload extends Controller {

  def index = Action {
    Ok(views.html.upload.index())
  }

  def upload = Action(parse.multipartFormData) { request =>
    UploadFile.upload(request.body.file("fileToUpload")) match {
      case "SUCCESS" =>
        val brain = new Brain
        brain.start()
        Ok("File uploaded")
      case "INVALID_CONTENT_TYPE" => Ok("Failed to upload: invalid content type")
      case "FAIL" => Ok("Failed to upload")
    }
  }

}
