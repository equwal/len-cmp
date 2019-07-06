;;;; An attempt to define an efficient length comparator.
#+5am (5am:def-suite length-tests :description "Test length functions.")
#+5am (5am:in-suite length-tests)

(in-package :cl-user)

(defun null0 (list)
  "Normalize a list variable to be numeric for length computation."
  (if (null list) 0 1))

#+5am (5am:test null0 (5am:is-true (and (= 1 (null0 '(1)))
                                        (= 0 (null0 nil)))))

(defun len (a b &optional predicate)
  "Compare length in a variety of efficient ways."
  (let ((predicate (if predicate predicate #'=)))
    (if (integerp a)
        (len-int a b predicate)
        (len-list a b predicate))))

(defun len-int (a b predicate)
  (declare (integer a)
           ((or null cons) b))
  (if (or (= 0 a) (null b))
      (funcall predicate a (null0 b))
      (len-int (1- a) (cdr b) predicate)))

(defun len-list (a b predicate)
  (declare ((or null cons) a b))
  (if (and a b)
      (len-list (cdr a) (cdr b) predicate)
      (funcall predicate (null0 a) (null0 b))))

#+5am (5am:test len-list (5am:is-true (and (len '(1) '(1 2) #'<)
                                           (len '(1) '(1) #'=))))
#+5am (5am:test len-int (5am:is-true (and (len 1 '(1))
                                          (len 0 nil)
                                          (not (len 1 '(1 2)))
                                          (not (len 1 nil)))))
(defun benchmark (fastp)
  (labels ((range (from to val)
             (loop for x from from to to
                   collect val)))
    (let ((range (range 0 10000000 nil))) ;; 10 million item list of nil
      (null (time (if fastp
                      (len range '(1))
                      (length range)))))))
