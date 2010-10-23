(use-package :sb-thread)

;; number of threads
(defparameter *nt* 10)

;; threads
(defvar *threads* '())

;; mutex to use with shared resource accessed by the threads
(defvar *a-mutex* (make-mutex :name "acc-lock"))

;; shared closure accessed by the threads
(let ((x '()))
  (defun acc (v)
	(with-mutex (*a-mutex*)
				(push v x)))
  (defun get-acc ()
	x))

;; print the shared resource
(print (get-acc))

;; wait for all the threads to return
(mapcar #'join-thread
		;; run the threads
		(loop :for i :below *nt* 
			  ;; bind i to x so it is local to the thread
			  :collect (let ((x i)) 
						(make-thread #'(lambda () 
										 ;; body of the thread
										 (sleep (random 2))
										 (acc x))
									 :name x))))

;; print the shared resource
(print (get-acc))
