#!/bin/sh
set -eu
mkdir -p target/classes target/test-classes
javac --release 21 -encoding UTF-8 -d target/classes src/main/java/fr/tp/demo/*.java
javac --release 21 -encoding UTF-8 -cp target/classes -d target/test-classes src/test/java/fr/tp/demo/*.java
java -cp target/classes:target/test-classes fr.tp.demo.GreetingTest
