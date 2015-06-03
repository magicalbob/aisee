package ai

object Brain {

  val NeuronFiringInterval = 500
  val neurons = OpticNerve.neurons ++= LateralGeniculateNucleus.neurons
  val neuronsInBuffer = collection.mutable.ArrayBuffer.empty[String]
  val neuronsToBeFired = collection.mutable.ArrayBuffer.empty[String]

  OpticNerve.neurons.foreach { case (neuronReference, neuron) =>
    neuronsInBuffer += neuronReference
  }

  val activity = new Thread(new Runnable {
    def run(): Unit = {
      while(true) { fireNeurons(); Thread sleep NeuronFiringInterval }
    }
  })

  def fireNeurons(): Unit = {
    neuronsToBeFired.clear()
    neuronsToBeFired ++= neuronsInBuffer
    neuronsInBuffer.clear()
    neuronsToBeFired.foreach { neuronReference =>
      neurons(neuronReference).fire(neuronReference)
    }
  }

}