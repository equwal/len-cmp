;;;; An attempt to define an efficient length comparator.
#+5am (5am:def-suite length-tests :description "Test length functions.")
#+5am (5am:in-suite length-tests)

(in-package :cl-user)

(defun null0 (list)
  "Normalize a list variable to be numeric for length computation."
  (if (null list) 0 1))

#+5am (5am:test null0 (5am:is-true (and (= 1 (null0 '(1)))
                                        (= 0 (null0 nil)))))

(defgeneric len (a b &optional predicate)
  (:documentation "Compare length in a variety of efficient ways."))

(defmethod len ((a integer) (b list) &optional (predicate #'=))
  ;; (declare (ftype (function ((integer 0 *) (integer 0 *)) t) predicate))
  (if (or (= 0 a) (null b))
      (funcall predicate a (null0 b))
      (len (1- a) (cdr b))))

(defmethod len ((a list) (b list) &optional (predicate #'=))
  ;; (declare (ftype (function ((integer 0 *) (integer 0 *)) t) predicate))
  (if (and a b)
      (len (cdr a) (cdr b) predicate)
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
