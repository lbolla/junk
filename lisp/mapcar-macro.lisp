;; from http://groups.google.co.uk/group/comp.lang.lisp/browse_thread/thread/89a4f5a778ef040e/57a6226762a2fae8?lnk=gst&q=mapcar+macro#57a6226762a2fae8


;; Pascal Bourguignon

(defun my-defun* (nr) 
  (destructuring-bind (name &rest rest) nr 
    (setf (fdefinition name) (compile nil `(lambda () (block ,name (list ,@rest))))) 
    name))

(defun my-defun2* (nr) 
  (destructuring-bind (name &rest rest) nr 
    (setf (fdefinition name) (compile nil `(lambda (,@rest) (block ,name (list ,@rest))))) 
    name))


;; Alessio Stalla

(defmacro my-defun ((name &rest rest)) 
  `(defun ,name () 
	 (list ,@rest)))

(defmacro generate-calls (operator &rest arglists) 
  `(progn 
	 ,@(mapcar (lambda (arglist) `(,operator ,@arglist)) arglists))) 

(generate-calls my-defun (f1 1) (f2 2) (f3 3))
