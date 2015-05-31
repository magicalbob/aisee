package ai

import play.api.Logger

object Brain {

  val NeuronFiringInterval = 500

  val activity = new Thread(new Runnable {
    def run(): Unit = {
      while(true) { fireNeuronsInBuffer(); Thread sleep NeuronFiringInterval }
    }
  })

  def fireNeuronsInBuffer(): Unit = {
    Logger.info("Firing neurons in buffer")
  }

}