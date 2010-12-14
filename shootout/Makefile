SBCL=/usr/bin/sbcl
CC=/usr/bin/gcc

clean: gcc.clean sbcl.clean
	rm -f *~

pidigits.gcc_run: pidigits.c
	${CC} -pipe -Wall -O3 -fomit-frame-pointer -march=native -Os -fopenmp -mfpmath=sse -msse2 -lm -lgmp pidigits.c -o pidigits.gcc_run
gcc.run: pidigits.gcc_run
	time ./pidigits.gcc_run ${N}
gcc.clean:
	rm -f pidigits.gcc_run

pidigits.sbcl_compile: pidigits.sbcl
sbcl.core: pidigits.sbcl_compile pidigits.sbcl
	time ${SBCL} --userinit /dev/null --eval '(load "pidigits.sbcl_compile")'
sbcl.run: sbcl.core pidigits.sbcl_run
	time ${SBCL} --noinform --core sbcl.core --userinit /dev/null --load pidigits.sbcl_run ${N}
sbcl.clean:
	rm -f sbcl.core *.fasl

#  ########################################
#  # SBCL (Common Lisp)
#  ########################################
#  # (Note: arg to compile-file for trace: ':trace-file t')
#  SBCL_TRACE :=
#  #SBCL_TRACE := :trace-file t

#  %.sbcl_run: %.sbcl $(SBCL_SRCS) $(SBCL)
#      -@rm -f $@ ; \
#      COMPILE=$@; COMPILE=$${COMPILE%_run}_compile ; \
#      FILES="" ; \
#      for f in $(SBCL_SRCS) ; do cp $$f . ; FILES="$$FILES $${f##*/}" ; done ; \
#      for src in $$FILES ; do \
#         echo "(compile-file \"$$src\" $(SBCL_TRACE)) (load \"$$src\" :verbose nil :print nil)" >> $$COMPILE ; \
#         base=$${src%.*} ; \
#      done ; \
#      cp $< . ; MAIN=$< ; MAIN=$${MAIN##*/} ; \
#      (echo "(handler-bind ((sb-ext:defconstant-uneql " \
#           "    (lambda (c) (abort c)))) " \
#           "    (load (compile-file \"$$MAIN\" $(SBCL_TRACE))))" \
#           "(save-lisp-and-die \"sbcl.core\" :purify t)") >> $$COMPILE ; \
#      echo "SBCL built with: $(SBCL) --userinit /dev/null --batch --eval '(load \"$$COMPILE\")'" ; \
#      echo "### START $$COMPILE" ; cat $$COMPILE ; echo "### END $$COMPILE" ; echo ; \
#      $(SBCL) --noinform --userinit /dev/null --load $$COMPILE; \
#      echo "(main) (quit)" >> $@
#      -@echo "### START $@" ; cat $@ ; echo "### END $@" ; echo
