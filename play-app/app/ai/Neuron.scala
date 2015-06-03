package ai

class Neuron(connections: List[PostSynapticConnection]) {

  val postSynapticConnections: List[PostSynapticConnection] = connections
  var firingRate = 0

  def calculatePostSynapticEffect(connection: PostSynapticConnection): Int = {
    (firingRate * connection.ratio).toInt
  }

}