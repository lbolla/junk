(require 's-xml-rpc)

(defpackage :wp 
  (:use :cl :cl-user :s-xml-rpc))

(in-package :wp)

(defparameter +interfaces+ 
  '((get-blogs "wp.getUsersBlogs" username password)
	(get-tags "wp.getTags" blog-id username password)
	(get-comment-count "wp.getCommentCount" blog-id username password post-id)
	(get-post-status-list "wp.getPostStatusList" blog-id username password)
	(get-page-status-list "wp.getPageStatusList" blog-id username password)
	(get-page-templates "wp.getPageTemplates" blog-id username password)
	(get-options "wp.getOptions" blog-id username password)
	(delete-comment "wp.deleteComment" blog-id username password comment-id)
	(get-comment-status-list "wp.getCommentStatusList" blog-id username password)
	(get-page "wp.getPage" blog-id page-id username password)
	(get-pages "wp.getPages" blog-id username password)
	(get-page-list "wp.getPageList" blog-id username password)
	(delete-page "wp.deletePage" blog-id username password page-id)
	(get-authors "wp.getAuthors" blog-id username password)
	(get-categories "wp.getCategories" blog-id username password)
	(delete-category "wp.deleteCategory" blog-id username password category-id)
	(suggest-categories "wp.suggestCategories" blog-id username password category max-results)
	(get-comment "wp.getComment" blog-id username password comment-id))
  "Interface definition to WP services")

(defun defunwp (params) 
  (destructuring-bind (name service &rest rest) params
	(setf (fdefinition name) (compile nil `(lambda (host ,@rest  &optional (url "/xmlrpc.php")) (block ,name 
																	 (xml-rpc-call 
																	   (encode-xml-rpc-call ,service ,@rest)
																	   :host host
																	   :url url)))))
	name))

(mapcar #'(lambda (interface) (defunwp interface) (export (car interface))) +interfaces+)
