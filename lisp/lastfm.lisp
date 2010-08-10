(require 's-xml-rpc)

(defpackage :lastfm
  (:use :cl :cl-user :s-xml-rpc)
  (:export auth-get-token))

(in-package :lastfm)

(defun auth-get-token (api_key api_sig &optional (host "ws.audioscrobbler.com") (url "/2.0"))
	(xml-rpc-call 
	  (encode-xml-rpc-call 
		"auth.getToken"
		(xml-rpc-struct 
		  "api_key" api_key
		  "api_sig" api_sig))
	  :host host
	  :url url))

(defun album-get-info (api_key album artist &optional (host "ws.audioscrobbler.com") (url "/2.0"))
	(xml-rpc-call 
	  (encode-xml-rpc-call 
		"album.getInfo"
		(xml-rpc-struct 
		  "api_key" api_key
		  "album" album
		  "artist" artist))
	  :host host
	  :url url))

(defun library-get-artists (api_key username &optional (host "ws.audioscrobbler.com") (url "/2.0"))
	(xml-rpc-call 
	  (encode-xml-rpc-call 
		"library.getArtists"
		(xml-rpc-struct 
		  "api_key" api_key
		  "user" username))
	  :host host
	  :url url))

;; TODO not working
; (defmacro defunlastfm (name service &rest rest)
;   `(defun ,name (,@rest &optional (host "ws.audioscrobbler.com") (url "/2.0"))
;      (xml-rpc-call 
;        (encode-xml-rpc-call ,service
;                             ,@(mapcar #'(lambda (p) `(xml-rpc-struct (symbol-name ,p) (symbol-value ,p))) rest))
;        :host host
;        :url url)))
