(defun my-but-last (lst)
  (if (null (cddr lst))
	lst
	(my-but-last (cdr lst))))
