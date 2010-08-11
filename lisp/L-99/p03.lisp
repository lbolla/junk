(defun element-at (lst n)
  (cond ((or (< n 0) (null lst)) nil)
		((= n 0) (car lst))
		(t (element-at (cdr lst) (1- n)))))

(defun element-at-iter (lst n)
  (when (>= n 0)
	(do ((i 0 (1+ i))
		 (x lst (cdr x))
		 (y (car lst) (car x)))
	  ((or (= i n) (null y)) y))))