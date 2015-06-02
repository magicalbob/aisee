package ai

object OpticNerve {

  val imageWidth = 16
  val imageHeight = 16
  val neurons = collection.mutable.Set.empty[Neuron]

  for(x <- 0 until imageWidth; y <- 0 until imageHeight){
    val neuron = new Neuron("n" + x.toString + "_" + y.toString)
    neuron.firingRate = x*y
    neurons += neuron
  }

}