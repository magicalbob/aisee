package ai

object LateralGeniculateNucleus {

  val id = "LGN"
  val neurons = collection.mutable.LinkedHashMap.empty[String, Neuron]

  for (x <- 0 until Image.width; y <- 0 until Image.height){
    val neuronReferenceMiddleRight = Array[String](id, x.toString, y.toString, "MR").mkString("_")
    val neuronReferenceBottomMiddle = Array[String](id, x.toString, y.toString, "BM").mkString("_")
    val neuronMiddleRight = new Neuron(List.empty[PostSynapticConnection])
    val neuronBottomMiddle = new Neuron(List.empty[PostSynapticConnection])
    neurons += (neuronReferenceMiddleRight -> neuronMiddleRight)
    neurons += (neuronReferenceBottomMiddle -> neuronBottomMiddle)
  }

}
