(defun my-reverse (lst)
  (if (null lst)
	nil
	(append (my-reverse (cdr lst)) (list (car lst)))))

;; tail recursive version
(defun my-reverse-tr (lst)
  (labels ((rec (lst acc)
				(if (null lst)
				  acc
				  (rec (cdr lst) (cons (car lst) acc)))))
	(rec lst '())))
