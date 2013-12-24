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

;; 1.6 为什么 if 需要作为一种特殊形式，而不能通过 cond 写成一个普通过程？
;; 下面是我们本来定义的sqrt 函数:
(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (good-enough? guess x)
  (< (abs (- (square guess)
             x))
     0.001))

(define (improve guess x)
  (average guess
           (/ x
              guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (square x)
  (* x x))

;; 下面是使用 cond 实现的 new-if
(define (new-if predicate then-clause else-clause)
  (cond
   (predicate then-clause)
   (else else-clause)))

;; 使用 new-if 替代 if
(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

;; 放在 mit-scheme 中执行:
;; 1 ]=> (sqrt 4)
;; Aborting!: maximum recursion depth exceeded

;; 解释器按照应用序在执行 new-if 时会对 predicate, then-clause, else-clause 求值
;; 这里我们的 else-clause 部分进行了递归调用。最终超过解释器递归深度。

;; 由于 sqrt-iter 的值还要作为 new-if 的参数，所以这里并不是尾递归。也就不能进行尾递归消除

;; 为了说明这一点，看下面的实例程序:
> (new-if (> 2 1) (display "hel") (display "lo"))
hello
> (if (> 2 1)(display "hel") (display "lo"))
hel

;; if 是作为一种特殊形式实现的，当 predicaet 为真时，它只有一个分支会被求值。
;; 而 new-if 作为普遍过程，需要两个分支都会被求值的。


;; 1.7 good-enough? 的策略为监测猜测值从一次迭代到下一次的变化情况，当
;; 改变值相对于猜测值的比例很小时就结束
(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (sqrt-iter guess x)
  (if (good-enough? guess (improve guess x))
      (improve guess x)
      (sqrt-iter (improve guess x)
                 x)))

;; 新的 good-enough?
(define (good-enough? old-guess new-guess)
    (> 0.01
       (/ (abs (- new-guess old-guess))
          old-guess)))

(define (improve guess x)
  (average guess
           (/ x
              guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (square x)
  (* x x))
