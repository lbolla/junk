(defun split (lst n)
  (labels ((rec (lst n acc)
				(cond ((null lst) (nreverse acc))
					  ((<= n 0) 
					   (if acc 
						 (list (nreverse acc) lst) 
						 lst))
					  (t (rec (cdr lst) (1- n) (cons (car lst) acc))))))
	(rec lst n '())))

