(defun my-last (lst)
  (let ((rst (cdr lst)))
	(if (null rst)
	  lst
	  (my-last rst))))
