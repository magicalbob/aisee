package ai

class OpticNerve {

  val neurons = collection.mutable.LinkedHashMap.empty[String, Neuron]
  val image = new TestImage

  for(x <- 0 until image.width; y <- 0 until image.height){

    val neuronReference = Array[String]("ON", x.toString, y.toString).mkString("_")
    val postSynapticConnectionsBuffer = collection.mutable.ListBuffer.empty[PostSynapticConnection]

    // Excites LGN neuron on same pixel for middle-right border
    postSynapticConnectionsBuffer += PostSynapticConnection("E", 1F,
      Array[String]("LGN", x.toString, y.toString, "MR").mkString("_"))

    // Excites LGN neuron on same pixel for bottom-middle border
    postSynapticConnectionsBuffer += PostSynapticConnection("E", 1F,
      Array[String]("LGN", x.toString, y.toString, "BM").mkString("_"))

    // Inhibits LGN neuron on pixel to the middle-left
    if (!image.pixelOutOfBounds(x - 1, y)) {
      postSynapticConnectionsBuffer += PostSynapticConnection("I", 1F,
        Array[String]("LGN", (x-1).toString, y.toString, "MR").mkString("_"))
    }

    // Inhibits LGN neuron on pixel to the top-middle
    if (!image.pixelOutOfBounds(x, y - 1)) {
      postSynapticConnectionsBuffer += PostSynapticConnection("I", 1F,
        Array[String]("LGN", x.toString, (y-1).toString, "BM").mkString("_"))
    }

    val postSynapticConnections = postSynapticConnectionsBuffer.toList
    val neuron = new Neuron(postSynapticConnections)
    neuron.firingRate = x*y
    neurons += (neuronReference -> neuron)
  }

}

class TestImage {
  val width = 16
  val height = 16
  def pixelOutOfBounds(x: Int, y: Int): Boolean = {
    (x < 0) || (y < 0) || (x > width - 1) || (y > height - 1)
  }
}