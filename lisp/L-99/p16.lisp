(defun drop (lst n)
  (let ((c 0))
	(defun eqp (n) 
	  (zerop (rem (incf c) n)))
	(defun rst () (setf c 0)))
  (rst)
  (remove-if #'(lambda (x) (eqp n)) lst))
