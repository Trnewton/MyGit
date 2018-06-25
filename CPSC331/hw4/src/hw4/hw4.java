/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hw4;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.List;
import java.util.concurrent.TimeUnit;
import javax.swing.JFrame;

/**
 *
 * @author thomasnewton
 */
public class hw4 {

    private static MazeVisualizer visual;

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        JFrame f = new JFrame("MazeVisualizer");
        f.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
        MazeSolver solver;
        visual = null;
        String option = null;
        String maze_file = null;
        String query_file = null;

        try {
            option = args[0];
            maze_file = args[1];
            query_file = args[2];
        } catch (Exception e) {
            System.out.println("ERROR: Invalid calling. \n Usage: java HW4 "
                    + "[option] maze-file query-file");
            System.out.println(e.toString());
            System.exit(0);
        }

        solver = new MazeSolver(readMaze(maze_file));
        BufferedReader input_query = null;
        try {
            input_query = new BufferedReader(new FileReader(query_file));
            String line = input_query.readLine();
            while (line != null) {
                String[] words = line.split("\t");
                int from, to;
                from = Integer.parseInt(words[0]);
                to = Integer.parseInt(words[1]);
                List<Integer> list = solver.dijkstraSolve(from, to);
                for (int i = 0; i < list.size(); i++) {
                    list.set(i, list.get(i) + 1);
                }
                System.out.print("Path from " + from + " to " + to + ": ");
                if (list.size() == 1 && from != to) {
                    System.out.println("No path found");
                } else {
                    System.out.println(list);
                }
                visual.addPath(list);
                line = input_query.readLine();
            }
        } catch (Exception e) {
            // System.out.println("ERROR Performing Query\n" + e.toString());
            e.printStackTrace();
            System.exit(0);
        } finally {
            if (input_query != null) {
                try {
                    input_query.close();
                } catch (Exception e) {
                    System.out.println("ERROR:Problem closing file \n" + e.toString());
                    System.exit(0);
                }
            }
        }
        f.getContentPane().add("Center", visual);
        visual.init();
        f.pack();
        f.setBackground(Color.WHITE);
        f.setSize(new Dimension(512, 512));
        f.setVisible(true);
    }

    private static Vertex[] readMaze(String maze_file) {
        Vertex[] vertices = null;
        BufferedReader input_maze = null;
        try {
            input_maze = new BufferedReader(new FileReader(maze_file));
            String line = input_maze.readLine();
            String[] words = line.split(" ");
            int n = Integer.parseInt(words[0]);
            visual = new MazeVisualizer(n);
            n = n * n;
            vertices = new Vertex[n];
            for (int i = 0; i < n; i++) {
                vertices[i] = new Vertex(i);
            }

            line = input_maze.readLine();
            while (line != null) {
                words = line.split("\t");
                int from, to, weight;
                from = Integer.parseInt(words[0]);
                to = Integer.parseInt(words[1]);
                weight = Integer.parseInt(words[2]);
                visual.addEdge(from, to);
                vertices[from - 1].addAdj(to - 1, weight);
                line = input_maze.readLine();
            }
        } catch (Exception e) {
            System.out.println("ERROR:File Reader \n" + e.toString());
            System.exit(0);
        } finally {
            if (input_maze != null) {
                try {
                    input_maze.close();
                } catch (Exception e) {
                    System.out.println("ERROR:Problem closing file \n" + e.toString());
                    System.exit(0);
                }
            }
        }
        return (vertices);
    }

}
