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
import java.util.concurrent.TimeUnit;
import javax.swing.JFrame;

/**
 *
 * @author thomasnewton
 */
public class hw4 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        String option = null;
        String maze_file = null;
        String query_file = null;
        MazeVisualizer visual;
        try {
            option = args[0];
            maze_file = args[1];
            query_file = args[2];
        } catch (Exception e) {
            System.out.println("ERROR: Invalid calling. \n Usage: java HW4 "
                    + "[option] maze-file query-file");
            System.out.println(e.getMessage());
            System.exit(0);
        }
        try {
            System.out.println(maze_file);
            BufferedReader input_maze = new BufferedReader(new FileReader(maze_file));
            String line = input_maze.readLine();
            String[] words = line.split(" ");
            int n = Integer.parseInt(words[0]);
            visual = new MazeVisualizer(n);
            //<editor-fold defaultstate="collapsed" desc="Window Init">
            JFrame f = new JFrame("MazeVisualizer");
            f.addWindowListener(new WindowAdapter() {
                public void windowClosing(WindowEvent e) {
                    System.exit(0);
                }
            });
            f.getContentPane().add("Center", visual);
            visual.init();
            f.pack();
            f.setBackground(Color.WHITE);
            f.setSize(new Dimension(512, 512));
            f.setVisible(true);
//</editor-fold>
            line = input_maze.readLine();
            while (line != null) {
                words = line.split("\t");
                visual.addEdge(Integer.parseInt(words[0]), Integer.parseInt(words[1]));
                line = input_maze.readLine();
            }
        } catch (Exception e) {
            System.out.println("ERROR:File Reader " + e.getMessage());
        }

    }

}
