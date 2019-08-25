# Usage
The only external function is `len`. 

```common-lisp
(len <integer or list> <list> &optional (<predicate> #'=))
(len 3 '(1 2 3)) ;=> T
(len '(a b c) '(1 2 3)) ;=> T
(len 3 '(1 2 3) #'/=) ;=> NIL
```
