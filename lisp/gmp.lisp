(defpackage :cl-gmp
  (:use :cl :sb-alien))

(in-package :cl-gmp)

(define-alien-type mp-limb-t unsigned-int)
(define-alien-type mp-bitcnt-t unsigned-long)
(define-alien-type mpz-struct
				   (struct nil
						   (mp-alloc int)
						   (mp-size int)
						   (mp-d mp-limb-t)))
(define-alien-type mpz-ptr (* mpz-struct))
(define-alien-type mpz-srcptr (* mpz-struct))

(defmacro define-gmp-interface (lisp-name c-name &rest params)
  (let ((named-params (cons (first params) 
							(mapcar #'(lambda (p) (list (gensym) p)) (rest params)))))
	`(progn
	   (declaim (inline ,lisp-name))
	   (export (define-alien-routine (,c-name ,lisp-name)
									 ,@named-params)))))

(define-gmp-interface mpz-init 
				  "__gmpz_init"
				  void
				  mpz-ptr)

(define-gmp-interface mpz-init-set-ui
				  "__gmpz_init_set_ui"
				  void
				  mpz-ptr
				  unsigned-long)

(define-gmp-interface mpz-get-ui
				  "__gmpz_get_ui"
				  unsigned-long
				  mpz-srcptr)

(define-gmp-interface mpz-set-ui
				  "__gmpz_set_ui"
				  void
				  mpz-ptr
				  unsigned-long)

(define-gmp-interface mpz-cmp
				  "__gmpz_cmp"
				  int
				  mpz-srcptr
				  mpz-srcptr)

(define-gmp-interface mpz-add
				  "__gmpz_add"
				  void
				  mpz-ptr
				  mpz-srcptr
				  mpz-srcptr)

(define-gmp-interface mpz-mul-2exp
				  "__gmpz_mul_2exp"
				  void
				  mpz-ptr
				  mpz-srcptr
				  mp-bitcnt-t)

(define-gmp-interface mpz-fdiv-qr
				  "__gmpz_fdiv_qr"
				  void
				  mpz-ptr
				  mpz-ptr
				  mpz-srcptr
				  mpz-srcptr)

(define-gmp-interface mpz-mul-ui
				  "__gmpz_mul_ui"
				  void
				  mpz-ptr
				  mpz-srcptr
				  unsigned-long)

(define-gmp-interface mpz-mul-ui
				  "__gmpz_submul_ui"
				  void
				  mpz-ptr
				  mpz-srcptr
				  unsigned-long)

(defun test ()
  (load-shared-object "libgmp.so")
  (let ((a (make-alien mpz-struct))
        (b (make-alien mpz-struct))
        (c (make-alien mpz-struct)))
	(mpz-init-set-ui a 1)
	(mpz-init-set-ui b 2)
	(mpz-init c)
	(mpz-add c a b)
	(format t "1 + 2 = ~D~%" (mpz-get-ui c))))

