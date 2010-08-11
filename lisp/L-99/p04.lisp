(defun my-length (lst)
  (if (null lst)
	0
	(1+ (my-length (cdr lst)))))

;; tail recursive version
(defun my-length-tr (lst)
  (labels ((rec (lst n)
				(if (null lst)
				  n
				  (rec (cdr lst) (1+ n)))))
	(rec lst 0)))
