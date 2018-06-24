/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package quicksortempirical;

import java.util.Random;

/**
 *
 * @author thomasnewton
 */
public class QuickSortEmpirical {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        IntWrap[] array;
        IntWrap num = new IntWrap(0);
        QuickSort sort = new QuickSort();
        System.out.println("N \t| # Swaps\t| # Compares \t| Partition Ratio");
        for(int i = 10; i<26; i++){
            num.compareCount = 0;
            int N = (int) Math.pow(2, i);
            array = createArray(N);
            sort.quicksort(array);
            System.out.println(N + "\t" + sort.swapCount + "\t" + num.compareCount + 
                    "\t" + sort.partRatio/sort.numPart);
        }
    }
    
    private static IntWrap[] createArray(int length){
        Random rand = new Random();
        IntWrap[] array = new IntWrap[length];
        
        for(int i = 0; i<length; i++){
            array[i] = new IntWrap(rand.nextInt());
        }
        return(array);
    }
}
