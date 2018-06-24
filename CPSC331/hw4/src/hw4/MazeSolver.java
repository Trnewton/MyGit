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
public class MazeSolver {
    private Vertex[] vertices;
    private double[] distArray;
    private Vertex[] queue;
    private int count;
    
    public MazeSolver(Vertex[] initVertices){
        vertices = initVertices;
    }
    
    public void dijkstraSolve(int from, int to){
        distArray = new double[vertices.length];
        queue = new Vertex[vertices.length];
        count = 0;
        
        for(Vertex v: vertices){
            Vertex copy = new Vertex(v);
            enqueue(copy, Double.POSITIVE_INFINITY);
        }
        distArray[from-1] = 0;
   }
    
    private double getDist(Vertex vertex){
        return(distArray[vertex.id-1]);
    }
    
    private void enqueue(Vertex vertex, double dist){
        distArray[count] = dist;
        queue[count] = vertex;
         
        int parentIndex = (count-1)/2;
        Vertex parent = queue[parentIndex];
        double parentDist = getDist(parent);
        
        int i = count;
        while(i>=0 && dist<parentDist){
            Vertex temp = parent;
            queue[parentIndex] = vertex;
            queue[i] = temp;
            i = parentIndex;
            parentIndex = (int) Math.floor((i-1)/2);
            parent = queue[parentIndex];
            parentDist = getDist(parent);
        }
        count++;
    }
    
    private Vertex dequeue(){
        Vertex root = queue[0];
        
        for(int i=1;i<queue.length;i++){
            queue[i-1] = queue[i];
        }
        queue[count] = root;
        count--;
        //Restore heap
        return(root);
    }
    
    private void heapify(){
        int lastNonLeaf = (count/2)-1;
        if(count%2!=0){
            double nodeDist = getDist(queue[lastNonLeaf]);
            double childDist = getDist(queue[(2*lastNonLeaf)+1]);
            if(nodeDist > childDist){
                Vertex temp = queue[lastNonLeaf];
                queue[lastNonLeaf] = queue[(2*lastNonLeaf)+1];
                queue[(2*lastNonLeaf)+1] = temp;
            }
            lastNonLeaf++;
        }
        for(int i=lastNonLeaf; i>-1;i--){
            double lChildDist = getDist(queue[(2*i)+1]);
            double rChildDist = getDist(queue[(2*i)+2]);
            double nodeDist = getDist(queue[i]);
                    
            if(nodeDist > lChildDist){
                Vertex temp = queue[i];
                queue[i] = queue[(2*i)+1];
                queue[(2*i)+1] = temp;
                nodeDist = getDist(queue[i]);
            }
            
            if(nodeDist > rChildDist){
                Vertex temp = queue[i];
                queue[i] = queue[(2*i)+2];
                queue[(2*i)+2] = temp;
            }
        }
    }
}
