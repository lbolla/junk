(ql:quickload "drakma")
(ql:quickload "cl-ppcre")

(defparameter *url-re* "href\ *=\ *['\"](\\S+)['\"]")

(defun find-links (str)
  (let ((urls '()))
	(ppcre:do-register-groups
	  (u) (*url-re* str nil :start 0 :sharedp t) 
	  (pushnew u urls :test #'equalp))
  (nreverse urls)))

(print
  (find-links (drakma:http-request "http://lbolla.wordpress.com")))
