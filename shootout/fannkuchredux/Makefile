clean: python.clean sbcl.clean
	rm -f *~

python.run: fannkuchredux.py
	time python fannkuchredux.py ${N}
python.clean:
	rm -f fannkuchredux.pyc

fannkuchredux.sbcl_compile: fannkuchredux.sbcl
sbcl.core: fannkuchredux.sbcl_compile fannkuchredux.sbcl
	time sbcl --userinit /dev/null --eval '(load "fannkuchredux.sbcl_compile")'
sbcl.run: sbcl.core fannkuchredux.sbcl_run
	time sbcl --noinform --core sbcl.core --userinit /dev/null --load fannkuchredux.sbcl_run ${N}
sbcl.clean:
	rm -f sbcl.core *.fasl
