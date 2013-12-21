;; 1.1 将以下表达式输入解释器，看看会输出什么结果
> 10
10
> (+ 5 3 4)
12
> (- 9 1)
8
> (/ 6 2)
3
> (+ (* 2 4) (- 4 6))
6
> (define a 3)
> (define b (+ a 1))
> (+ a b (* a b))
19
> (= a b)
#f
> (if (and (> b a) (< b (* a b)))
      b
      a)
4
> (cond ((= a 4) 6)
        ((= b 4) (+ 6 7 a))
        (else 25))
16
> (+ 2 (if (> b a) b a))
6
> (*
   (cond
    ((> a b) a)
    ((< a b) b)
    (else -1)
    )
   (+ a 1)
   )
16

;; 1.2 将给定表达式转换成前缀形式
> (/
   (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5)))))
   (* 3 (- 6 2) (- 2 7))
   )
-37/150

;; 1.3定义一个过程，它又三个参数，返回较大的两个数的平方和
;; 这个问题最重要的部分是如何求出三个数中较大的两个，一个简单的决策树就可以解决
;; 至于决策树的表达可以用 cond 也可以用if
> (define (square x) (* x x))
> (define (sum-of-square x y) (+ (square x) (square y)))
> (define (sum-of-squared-bigger x y z)
    (cond
     ((and (> x y) (> y z)) (sum-of-square x y))
     ((and (> x y) (> z y)) (sum-of-square x z))
     ((and (> y x) (> x z)) (sum-of-square y x))
     ((and (> y x) (> z x)) (sum-of-square y z))
     )
    )
> (sum-of-squared-bigger 1 2 3)
13

;; 1.4 运算符部分是复合表达式的情况
(define (a-plus-abs-b a b)
    ((if (> b 0) + -) a b))
;; if 表示的谓词的 e 部分将返回过程 + 或者 -，而不像以往返回数字
(define (p) (p))
(define (test x y)
  (if (= x 0)
      0
      y))
(test 0 (p))

;; 1.5 测试解释器求值时到底使用的应用序还是正则序
;; 在应用序下，先对参数求值，在对参数 (p) 求值时将进入无限的递归调用中

;; 在正则序下，过程会先展开，直到有必要时开展开。因为if 所在过程中 0所
;; 在子句命中，自然不会调用 (p), 也就不会卡死
