package quicksortempirical;

/**
 * CPSC 331, Spring 2018
 *
 * Quicksort code adapted from:
 * Data Structures and Algorithms in Java, by Adam Drozdek
 * Available online at:
 * http://www.mathcs.duq.edu/drozdek/DSinJava/
 */

public class QuickSort {
    long swapCount;
    long compareCount;
    double partRatio;
    double numPart;
    
    
    public void swap(Object[] a, int e1, int e2) {
        swapCount++;
        Object tmp = a[e1];
        a[e1] = a[e2];
        a[e2] = tmp;
    }
    
    private <T extends Comparable<? super T>> void quicksort(T[] data, int first,
            int last) {
        int lower = first + 1, upper = last;
        int part = (first+last)/2;
        swap(data,first,part);
        numPart++;
        partRatio += (double) Math.max(last-part, part-first)/(last-first);
        T bound = data[first];
        while (lower <= upper) {
            while (bound.compareTo(data[lower]) > 0){
                lower++;
            }
            while (bound.compareTo(data[upper]) < 0){
                upper--;
            }
            if (lower < upper)
                swap(data,lower++,upper--);
            else lower++;
        }
        swap(data,upper,first);
        if (first < upper-1){
            quicksort(data,first,upper-1);
        }
        if (upper+1 < last){
            quicksort(data,upper+1,last);
        }
    }
    
    public <T extends Comparable<? super T>> void quicksort(T[] data) {
        swapCount = 0;
        partRatio = 0;
        numPart = 0;
        if (data.length < 2)
            return;
        int max = 0;
        // find the largest element and put it at the end of data;
        for (int i = 1; i < data.length; i++){
            if (data[max].compareTo(data[i]) < 0)
                max = i;
        }
        swap(data,data.length-1,max);    // largest el is now in its
        quicksort(data,0,data.length-2); // final position;
    }
}
