name := baseDirectory.value.getName

version := "1.0-SNAPSHOT"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.6"

libraryDependencies ++= Seq(
  jdbc,
  anorm,
  cache,
  ws,
  "com.sksamuel.scrimage" %% "scrimage-core" % "1.4.2"
)
