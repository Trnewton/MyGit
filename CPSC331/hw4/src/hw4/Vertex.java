/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hw4;

/**
 *
 * @author thomasnewton
 */
public class Vertex {
    int id;
    int[][] adjacent = new int[4][];
    int count = 0;

    public Vertex(int initID){
        id = initID;
    }
    
    public Vertex(Vertex copy){
        id = copy.id;
        adjacent = copy.adjacent;
        count = copy.count;
    }
    
    public void addAdj(int vertexID, int weight){
        int[] array = new int[2];
        array[0] = vertexID;
        array[1] = weight;
        adjacent[count] = array;
        count++;
    }
    
    
}
