package ai

import play.api.Logger

class Neuron(reference: String) {

  var firingRate = 0

  def fire(): Unit  = {
    Logger.info("Neuron " + reference + " fired at rate " + firingRate.toString)
  }

}