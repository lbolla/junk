set datafile separator ","

set style line 1 lt 2 lc rgb "red" lw 3
set style line 2 lt 2 lc rgb "orange" lw 2
set style line 3 lt 2 lc rgb "yellow" lw 3
set style line 4 lt 2 lc rgb "green" lw 2

set key top left

plot "n2.csv" with points ls 3 title "O(n^2)", \
     "n_log_n.csv" with points ls 2 title "O(n lg n)", \
     "n.csv" with points ls 1 title "O(n)", \
     "insertionsort.csv" with l ls 3 title "insertionsort", \
     "heapsort.csv" with l ls 2 title "heapsort", \
     "mergesort.csv" with l ls 2 title "mergesort", \
     "qsort.csv" with l ls 2 title "qsort", \
     "counting_sort.csv" with l ls 1 title "countingsort", \
     "radix_sort.csv" with l ls 1 title "radixsort", \
     "bucket_sort.csv" with l ls 1 title "bucketsort"
