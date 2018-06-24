/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package quicksortempirical;

/**
 *
 * @author thomasnewton
 */
public class IntWrap implements Comparable{
    static int compareCount;
    int num;
    
    public IntWrap(int i){
        num = i;
    }
    
    public Integer getVal(){
        return(num);
    }

    @Override
    public int compareTo(Object o) {
        return(compareTo((IntWrap) o));
    }
    
    public int compareTo(IntWrap o) {
        compareCount++;
        return ( (this.num < o.num) ? -1:(this.num > o.num) ? 1:0);
    }
}
