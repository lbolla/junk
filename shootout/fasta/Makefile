SBCL=sbcl
CC=gcc

clean: gcc.clean sbcl.clean
	rm -f *~

fasta.gcc_run: fasta.c
	${CC} -pipe -Wall -std=c99 -O3 -fomit-frame-pointer -march=native -Os -mfpmath=sse -msse2 -lm fasta.c -o fasta.gcc_run
gcc.run: fasta.gcc_run
	time ./fasta.gcc_run ${N}
gcc.clean:
	rm -f fasta.gcc_run

fasta.sbcl_compile: fasta.sbcl
sbcl.core: fasta.sbcl_compile fasta.sbcl
	time ${SBCL} --userinit /dev/null --eval '(load "fasta.sbcl_compile")'
sbcl-orig.run: sbcl-orig.core
	time ${SBCL} --noinform --core sbcl-orig.core --userinit /dev/null --load fasta.sbcl_run ${N}
sbcl.run: sbcl.core fasta.sbcl_run
	time ${SBCL} --noinform --core sbcl.core --userinit /dev/null --load fasta.sbcl_run ${N}
sbcl.clean:
	rm -f sbcl.core *.fasl
