package ai

object OpticNerve {

  val id = "ON"
  val neurons = collection.mutable.LinkedHashMap.empty[String, Neuron]

  for(x <- 0 until Image.width; y <- 0 until Image.height){

    val neuronReference = Array[String](id, x.toString, y.toString).mkString("_")
    val postSynapticConnectionsBuffer = collection.mutable.ListBuffer.empty[PostSynapticConnection]

    // Excites LGN neuron on same pixel for middle-right border
    postSynapticConnectionsBuffer += PostSynapticConnection("E", 1F,
      Array[String](LateralGeniculateNucleus.id, x.toString, y.toString, "MR").mkString("_"))

    // Excites LGN neuron on same pixel for bottom-middle border
    postSynapticConnectionsBuffer += PostSynapticConnection("E", 1F,
      Array[String](LateralGeniculateNucleus.id, x.toString, y.toString, "BM").mkString("_"))

    // Inhibits LGN neuron on pixel to the middle-left
    if (!Image.pixelOutOfBounds(x - 1, y)) {
      postSynapticConnectionsBuffer += PostSynapticConnection("I", 1F,
        Array[String](LateralGeniculateNucleus.id, (x-1).toString, y.toString, "MR").mkString("_"))
    }

    // Inhibits LGN neuron on pixel to the top-middle
    if (!Image.pixelOutOfBounds(x, y - 1)) {
      postSynapticConnectionsBuffer += PostSynapticConnection("I", 1F,
        Array[String](LateralGeniculateNucleus.id, x.toString, (y-1).toString, "BM").mkString("_"))
    }

    val postSynapticConnections = postSynapticConnectionsBuffer.toList
    val neuron = new Neuron(postSynapticConnections)
    neuron.firingRate = x*y
    neurons += (neuronReference -> neuron)
  }

}