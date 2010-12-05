SBCL=sbcl
CC=gcc

clean: gcc.clean sbcl.clean
	rm -f *~

spectralnorm.gcc_run: spectralnorm.c
	${CC} -pipe -Wall -O3 -fomit-frame-pointer -march=native -Os -fopenmp -mfpmath=sse -msse2 -lm spectralnorm.c -o spectralnorm.gcc_run
gcc.run: spectralnorm.gcc_run
	time ./spectralnorm.gcc_run ${N}
gcc.clean:
	rm -f spectralnorm.gcc_run

spectralnorm.sbcl_compile: spectralnorm.sbcl
sbcl.core: spectralnorm.sbcl_compile
	time ${SBCL} --userinit /dev/null --eval '(load "spectralnorm.sbcl_compile")'
sbcl.run: sbcl.core spectralnorm.sbcl_run
	time ${SBCL} --noinform --core sbcl.core --userinit /dev/null --load spectralnorm.sbcl_run ${N}
sbcl.clean:
	rm -f sbcl.core *.fasl
