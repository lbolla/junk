(asdf:oos 'asdf:load-op :drakma)
(asdf:oos 'asdf:load-op :cl-ppcre)

(defpackage :bench
  (:use :cl :drakma :cl-ppcre))

(in-package :bench)

(defparameter *url-re* "href\ *=\ *[\"'](/\\S+)[\"']")

(let ((store (make-hash-table :test #'equalp))
	  (links '()))
  (defun reset-store ()
	(setf store (make-hash-table :test #'equalp))
	(setf links '()))
  (defun add-request (url req-time)
	(let ((data (gethash url store '(0 0))))
	  (setf 
		(gethash url store)
		(list
		  (+ (first data) req-time)
		  (1+ (second data))))))
  (defun add-link (l)
	(pushnew l links :test #'equalp))
  (defun next-link ()
	(nth (random (length links)) links))
  (defun get-links ()
	links)
  (defun get-store ()
	store)
  (defun reqs-per-sec ()
	(let ((number-of-requests 0)
		  (total-time 0)
		  (urls '()))
	  (maphash #'(lambda (k v)
				   (push (list 
						   k 
						   (float (/ (cadr v) (car v))))
						 urls)
				   (incf total-time (car v))
				   (incf number-of-requests (cadr v)))
			   store)
	  (when (> total-time 0)
		(mapcar #'(lambda (x)
					(format t "~A ~A~%" (car x) (cadr x)))
				(sort 
				  urls
				  #'(lambda (u v) (< (cadr u) (cadr v)))))
		(format t "Total: ~A~%" 
				(float (/ number-of-requests total-time)))))))

(defmacro time-it (&body body)
  `(let (t1 t2)
	 (setf t1 (get-internal-real-time))
	 ,@body
	 (setf t2 (get-internal-real-time))
	 (/ (- t2 t1) internal-time-units-per-second)))

(defun store-links (target-string)
  (do-register-groups
	(u) (*url-re* target-string nil :start 0 :sharedp t) 
	(add-link u)))

(defun req (url &optional &key strm)
  (let (page)
	(add-request
	  url
	  (time-it
		(setf page
			  ; (drakma:http-request url :stream strm :close nil))))
			  (drakma:http-request url))))
	(store-links page)))

(defun bench (base-url url &optional (nreqs 10))
  (let ((strm 
		  (nth-value 4 (drakma:http-request base-url :close nil))))
	(add-link url)
	(do ((u (next-link) (next-link))
		 (n 0 (1+ n)))
	  ((or (>= n nreqs) (null u)) 'finished)
	  (format t "Req url ~A~%" u)
	  (req 
		(format nil "~A~A" base-url u)
		:strm strm))))

(defun main ()
  (reset-store)
  ; (bench "http://localhost:4242" "/main" 30)
  ; (bench "http://test.geneity.co.uk:8013" "/" 30)
  (bench "http://usformdev" "/" 30)
  (format t "Req/sec ~A~%" (reqs-per-sec)))
