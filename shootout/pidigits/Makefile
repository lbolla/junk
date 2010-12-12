SBCL=sbcl
CC=gcc

clean: gcc.clean sbcl.clean
	rm -f *~

pidigits.gcc_run: pidigits.c
	${CC} -pipe -Wall -O3 -fomit-frame-pointer -march=native -Os -fopenmp -mfpmath=sse -msse2 -lm -lgmp pidigits.c -o pidigits.gcc_run
gcc.run: pidigits.gcc_run
	time ./pidigits.gcc_run ${N}
gcc.clean:
	rm -f pidigits.gcc_run

pidigits.sbcl_compile: pidigits.sbcl
sbcl.core: pidigits.sbcl_compile
	time ${SBCL} --userinit /dev/null --eval '(load "pidigits.sbcl_compile")'
sbcl.run: sbcl.core pidigits.sbcl_run
	time ${SBCL} --noinform --core sbcl.core --userinit /dev/null --load pidigits.sbcl_run ${N}
sbcl.clean:
	rm -f sbcl.core *.fasl
