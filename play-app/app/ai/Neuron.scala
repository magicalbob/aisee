package ai

class Neuron(connections: List[PostSynapticConnection]) {

  val postSynapticConnections: List[PostSynapticConnection] = connections
  var firingRate = 0

  def fire(neuronReference: String): Unit  = {
    postSynapticConnections.foreach { connection =>
      calculatePostSynapticEffect(connection)
      Brain.neuronsInBuffer += connection.connectedTo
    }
  }

  def calculatePostSynapticEffect(connection: PostSynapticConnection): Unit = {
    val effect = (firingRate * connection.ratio).toInt
    connection.typeOfEffect match {
      case "E" => Brain.neurons(connection.connectedTo).firingRate += effect
      case "I" => Brain.neurons(connection.connectedTo).firingRate -= effect
    }
  }

}