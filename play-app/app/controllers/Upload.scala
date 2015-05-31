package controllers

import play.api.mvc._
import models.UploadPng

object Upload extends Controller {

  def index = Action {
    Ok(views.html.upload.index())
  }

  def upload = Action(parse.multipartFormData) { request =>
    UploadPng.uploadPng(request.body.file("fileToUpload")) match {
      case "SUCCESS" => Ok("File uploaded")
      case "FAIL" => Ok("Failed to upload")
    }
  }

}
