package ai

import play.api.Logger

object Brain {

  val NeuronFiringInterval = 500
  val neuronsInBuffer = OpticNerve.neurons

  val activity = new Thread(new Runnable {
    def run(): Unit = {
      while(true) { fireNeuronsInBuffer(); Thread sleep NeuronFiringInterval }
    }
  })

  def fireNeuronsInBuffer(): Unit = {
    Logger.info("fireNeuronsInBuffer called")
    neuronsInBuffer.foreach { neuron => fire(neuron) }
  }

  def fire(neuron: Neuron): Unit = {
    neuron.fire()
    neuronsInBuffer -= neuron
  }

}