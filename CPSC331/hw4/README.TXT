Title: CPSC 331 - HW4
Author: Thomas Newton
UCID: 30029307
Date: 24/06/2018
Description:
Application that calculates and displays the shortest path between two nodes in a square maze. The application is called from the command line by first going to the hw4 folder and then using the follow:

	java -jar "hw4.jar" option maze-file query-file

where option = "weighted" or "unweighted". The maze is generated from the maze-file, which should start with a number indicating the number of nodes on one side of the square, and then each following line is of the form:

	<fromVertex>\t<toVertex> <weight>

The nodes to find the paths between is then given in the query-file, where each line should be of the following form:

	<source vertex>\t<target vertex>

Notes:

* If two JAR files on the project classpath have the same name, only the first
JAR file is copied to the lib folder.
* Only JAR files are copied to the lib folder.
If the classpath contains other types of files or folders, these files (folders)
are not copied.
* If a library on the projects classpath also has a Class-Path element
specified in the manifest,the content of the Class-Path element has to be on
the projects runtime path.
* To set a main class in a standard Java project, right-click the project node
in the Projects window and choose Properties. Then click Run and enter the
class name in the Main Class field. Alternatively, you can manually type the
class name in the manifest Main-Class element.
