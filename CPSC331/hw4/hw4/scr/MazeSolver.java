package hw4;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author thomasnewton
 */
public class MazeSolver {
    private Vertex[] vertices;
    private double[] distArray;
    private Vertex[] queue;
    private int count;

    public MazeSolver(int length) {
        count = 0;
        distArray = new double[length];
        queue = new Vertex[length];
    }

    public MazeSolver(Vertex[] initVertices) {
        vertices = initVertices;
        count = 0;
    }

    /**
     * Takes from and to nodes and finds the shortest path between the two using
     * Dijkstra's algorithm.
     * @param from
     * @param to
     * @param option
     * @return 
     */
    public List<Integer> dijkstraSolve(int from, int to, String option) {
        List<List<Integer>> paths;
        distArray = new double[vertices.length];
        queue = new Vertex[vertices.length];
        count = 0;

        for (Vertex v : vertices) {
            Vertex copy = new Vertex(v);
            if (option.equals("unweighted")) {
                copy.setWeights(1);
            }
            enqueue(copy, Double.POSITIVE_INFINITY);
        }
        distArray[from - 1] = 0;
        heapify();
        paths = new ArrayList<List<Integer>>(count);
        for (int i = 0; i < count; i++) {
            List<Integer> list = new ArrayList<Integer>();
            paths.add(list);
        }

        Vertex u;
        int n = 0;
        while (count > 0) {
            n++;
            u = dequeue();
            int[] v;
            for (int i = 0; i < u.count; i++) {

                v = u.adjacent[i];
                if (distArray[v[0]] > (getDist(u) + v[1])) {
                    distArray[v[0]] = getDist(u) + v[1];
                    List<Integer> path = paths.get(v[0]);
                    path.clear();
                    path.addAll(paths.get(u.id));
                    path.add(u.id);
                }
            }
            heapify();
        }
        for (int i = 0; i < paths.size(); i++) {
            List<Integer> path = paths.get(i);
            path.add(i);
        }
        return (paths.get(to - 1));
    }

    private double getDist(Vertex vertex) {
        return (distArray[vertex.id]);
    }

    private void enqueue(Vertex vertex, double dist) {
        distArray[count] = dist;
        queue[count] = vertex;

        int parentIndex = (count - 1) / 2;
        Vertex parent = queue[parentIndex];
        double parentDist = getDist(parent);

        int i = count;
        while (i >= 0 && dist < parentDist) {
            Vertex temp = parent;
            queue[parentIndex] = vertex;
            queue[i] = temp;
            i = parentIndex;
            parentIndex = (int) Math.floor((i - 1) / 2);
            parent = queue[parentIndex];
            parentDist = getDist(parent);
        }
        count++;
    }

    private Vertex dequeue() {
        int last = count - 1;
        Vertex root = queue[0];
        queue[0] = queue[last];
        queue[last] = root;
        last--;

        int firstLeaf = (last / 2);
        int n = 0;
        while (n < firstLeaf) {
            double lChildDist = getDist(queue[(2 * n) + 1]);
            double rChildDist = getDist(queue[(2 * n) + 2]);
            double nodeDist = getDist(queue[n]);
            int litChildPos = (lChildDist < rChildDist) ? (2 * n) + 1 : (2 * n) + 2;
            double litChildDist = getDist(queue[litChildPos]);

            if (nodeDist > litChildDist) {
                Vertex temp = queue[n];
                queue[n] = queue[litChildPos];
                queue[litChildPos] = temp;
                n = litChildPos;
            } else {
                break;
            }
        }

        count--;
        return (root);
    }

    private void heapify() {
        int lastNonLeaf = (count / 2) - 1;
        if ((count % 2 == 0) && (lastNonLeaf > 0)) {
            double nodeDist = getDist(queue[lastNonLeaf]);
            double childDist = getDist(queue[(2 * lastNonLeaf) + 1]);
            if (nodeDist > childDist) {
                Vertex temp = queue[lastNonLeaf];
                queue[lastNonLeaf] = queue[(2 * lastNonLeaf) + 1];
                queue[(2 * lastNonLeaf) + 1] = temp;
            }
            lastNonLeaf--;
        }
        for (int i = lastNonLeaf; i > -1; i--) {
            int n = i;
            while (n <= lastNonLeaf) {
                double lChildDist = getDist(queue[(2 * n) + 1]);
                double rChildDist = getDist(queue[(2 * n) + 2]);
                double nodeDist = getDist(queue[n]);
                int litChildPos = (lChildDist < rChildDist) ? (2 * n) + 1 : (2 * n) + 2;
                double litChildDist = getDist(queue[litChildPos]);

                if (nodeDist > litChildDist) {
                    Vertex temp = queue[n];
                    queue[n] = queue[litChildPos];
                    queue[litChildPos] = temp;
                    n = litChildPos;
                } else {
                    break;
                }
            }
            //printHeap();
        }
    }

    private void printQ() {
        for (Vertex v : queue) {
            System.out.print(distArray[v.id] + ", ");
        }
        System.out.println();
    }

    private void printHeap() {
        int n = 0;
        for (int i = 1; i < count; i = i * 2) {
            int j = 0;
            while (n < count && j < i) {
                System.out.print(distArray[queue[n].id] + ", ");
                n++;
                j++;
            }
            System.out.println();
        }
    }
}
