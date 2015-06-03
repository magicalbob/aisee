package ai

class Brain {

  val NeuronFiringInterval = 500

  val opticNerve = new OpticNerve
  val lateralGeniculateNucleus = new LateralGeniculateNucleus
  val neurons = opticNerve.neurons ++= lateralGeniculateNucleus.neurons

  val neuronsInBuffer = collection.mutable.ArrayBuffer.empty[String]
  val neuronsToBeFired = collection.mutable.ArrayBuffer.empty[String]

  def start(): Unit = {
    opticNerve.neurons.foreach { case (neuronReference, neuron) =>
      neuronsInBuffer += neuronReference
    }
    while (neuronsInBuffer.nonEmpty) { fireNeurons() }
  }

  def fireNeurons(): Unit = {
    switcheroo()
    neuronsToBeFired.foreach { preSynapticNeuron =>
      neurons(preSynapticNeuron).postSynapticConnections.foreach { connection =>
        neurons(connection.postSynapticNeuron).firingRate = connection.typeOfEffect match {
          case "E" => scala.math.abs(neurons(connection.postSynapticNeuron).firingRate +
            neurons(preSynapticNeuron).calculatePostSynapticEffect(connection))
          case "I" => scala.math.abs(neurons(connection.postSynapticNeuron).firingRate -
            neurons(preSynapticNeuron).calculatePostSynapticEffect(connection))
        }
        neuronsInBuffer += connection.postSynapticNeuron
      }
    }
  }

  def switcheroo(): Unit = {
    neuronsToBeFired.clear()
    neuronsToBeFired ++= neuronsInBuffer
    neuronsInBuffer.clear()
  }

}