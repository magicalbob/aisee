package ai

import play.api.Logger

class Neuron(connections: List[PostSynapticConnection]) {

  val postSynapticConnections: List[PostSynapticConnection] = connections
  var firingRate = 0

  def fire(neuronReference: String): Unit  = {
    Logger.info("Fired: " + neuronReference)
    postSynapticConnections.foreach { connection =>
      calculatePostSynapticEffect(connection)
      Brain.neuronsInBuffer += connection.connectedTo
      Logger.info("Connected to: " + connection.connectedTo)
    }
  }

  def calculatePostSynapticEffect(connection: PostSynapticConnection): Unit = {
    val effect = (firingRate * connection.ratio).toInt
    Brain.neurons(connection.connectedTo).firingRate = connection.typeOfEffect match {
      case "E" => scala.math.abs(Brain.neurons(connection.connectedTo).firingRate + effect)
      case "I" => scala.math.abs(Brain.neurons(connection.connectedTo).firingRate - effect)
    }
  }

}