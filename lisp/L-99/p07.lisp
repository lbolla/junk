(defun my-flatten (lst)
  (cond ((null lst) nil)
		((atom lst) (list lst))
		(t (append (my-flatten (car lst)) (my-flatten (cdr lst))))))
