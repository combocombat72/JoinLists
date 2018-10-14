import j-max,
       j-first,
       j-rest,
       j-length,
       j-nth,
       j-map,
       j-filter,
       j-sort,
       j-reduce

  from my-gdrive("join-lists-code.arr")

import shared-gdrive("join-lists-support.arr", "1OH25NKkXAwcOtXs9yGLAjZO3u65T6T0J") as S

type JoinList = S.JoinList
is-empty-join-list = S.is-empty-join-list
empty-join-list = S.empty-join-list
one = S.one
is-one = S.is-one
join-list = S.join-list
is-join-list = S.is-join-list
split = S.split
join-list-to-list = S.join-list-to-list
list-to-join-list = S.list-to-join-list
is-non-empty-jl = S.is-non-empty-jl

# DO NOT CHANGE ANYTHING ABOVE THIS LINE
#some example join-lists for testing:
#represents one(value)
j-list-1 = one(4)
j-list-2 = one(8)

#represents join-list(list1, list2, length)
#join-lists with arbitrary list1 and list2
j-list-3 = list-to-join-list([list: 3, 2])
j-list-4 = list-to-join-list([list: 1, 3, 5])
j-list-5 = list-to-join-list([list: 76, 34, 5, 12, 0, 7])
j-list-6 = list-to-join-list([list: 3, 4, 25, 3, 1, 7, 19, 21, 3])

check "j-first":
  #j-first on one(val)
  j-first(j-list-1) is 4
  j-first(j-list-2) is 8
  
  #j-first on j-list with more than one element
  j-first(j-list-3) is 3
  j-first(j-list-5) is 76
end

check "j-rest":
  #j-rest on list with one element
  j-rest(j-list-1) is empty-join-list
  j-rest(j-list-2) is empty-join-list
  
  #j-rest on j-list with more than one element
  j-rest(j-list-3) is list-to-join-list([list: 2])
  j-rest(j-list-4) is list-to-join-list([list: 3, 5])
  j-rest(j-list-5) is list-to-join-list([list: 34, 5, 12, 0, 7])
end

check "j-length":
  #j-length on empty-join-list
  j-length(empty-join-list) is 0
  
  #j-length on one(value)
  j-length(j-list-1) is 1
  j-length(j-list-2) is 1
  
  #j-length on j-list with more than one element
  j-length(j-list-3) is 2
  j-length(j-list-4) is 3
  j-length(j-list-5) is 6
  j-length(j-list-6) is 9
end

check "j-nth":
  #j-nth on one(value)
  j-nth(j-list-1, 0) is 4
  j-nth(j-list-2, 0) is 8
  
  #j-nth on jlist with more than one element
  j-nth(j-list-3, 0) is 3
  j-nth(j-list-3, 1) is 2
  j-nth(j-list-5, 3) is 12
  j-nth(j-list-6, 6) is 19
end

check "j-max":
  #greater than is a built-in pyret function
  #j-max on one(value)
  j-max(j-list-1, _greaterthan) is 4
  j-max(j-list-2, _greaterthan) is 8

  #j-max on jlist with more than one element
  j-max(j-list-3, _greaterthan) is 3
  j-max(j-list-4, _greaterthan) is 5
  j-max(j-list-5, _greaterthan) is 76
  j-max(j-list-6, _greaterthan) is 25
end

check "j-map":
  #Tests the empty case
  j-map(doubler, empty-join-list) is empty-join-list 
  
  #tests one(val)
  j-map(doubler, j-list-1) is one(8)
  j-map(sub-one, j-list-2) is one(7)
  
  #tests j-lists with more than one element
  j-map(doubler, j-list-4) is list-to-join-list([list: 2, 6, 10])
  j-map(sub-one, j-list-5) is list-to-join-list([list: 75, 33, 4, 11, -1, 6])
  j-map(doubler, j-list-6) 
    is list-to-join-list([list: 6, 8, 50, 6, 2, 14, 38, 42, 6])
end

#map helper functions for testing
fun doubler(a-num :: Number) -> Number:
  doc: "returns a-num * 2, for use in map"
  a-num * 2
where:
  doubler(-4) is -8
  doubler(0) is 0
  doubler(56) is 112
end

#map helper functions for testing
fun sub-one(a-num :: Number) -> Number:
  doc: "returns a-num - 1, for use in map"
  a-num - 1
where:
  sub-one(-4) is -5
  sub-one(0) is -1
  sub-one(56) is 55
end

check "j-filter":
  #Tests the empty case
  j-filter(is-even, empty-join-list) is empty-join-list 
  
  #tests one(value)
  j-filter(is-even, j-list-1) is j-list-1
  j-filter(greater-than-five, j-list-1) is empty-join-list
  
  #tests j-list with more than one value
  j-filter(is-even, j-list-4) is empty-join-list
  j-filter(greater-than-five, j-list-5) 
    is list-to-join-list([list: 76, 34, 12, 7])
  j-filter(is-even, j-list-5) 
    is list-to-join-list([list: 76, 34, 12, 0])
  j-filter(is-even, j-list-6) is one(4)
end

#filter helper functions for testing
fun is-even(a-num :: Number) -> Boolean:
  doc: "Returns true if a-num is even, false otherwise"
  num-modulo(a-num, 2) == 0
where:
  is-even(3) is false
  is-even(6) is true
  is-even(0) is true
end

fun greater-than-five(a-num :: Number) -> Boolean:
  doc: "returns true if a-num is greater than five"
  a-num > 5
where:
  greater-than-five(3) is false
  greater-than-five(6) is true
  greater-than-five(5) is false
end

check "j-reduce":
  #tests for one(value)
  j-reduce(mult, j-list-1) is 4
  j-reduce(add, j-list-2) is 8
  
  #tests for j-lists with more than one value
  j-reduce(mult, j-list-4) is 15
  j-reduce(add, j-list-4) is 9
  j-reduce(mult, j-list-5) is 0
  j-reduce(add, j-list-5) is 134
  j-reduce(add, j-list-6) is 86
end

#helper functions for j-reduce function
fun mult(num-1 :: Number, num-2 :: Number) -> Number:
  doc: "mulitiplies two numbers"
  num-1 * num-2
where:
  mult(3, 4) is 12
  mult(-2, 5) is -10
  mult(0, 34) is 0
end

fun add(num-1 :: Number, num-2 :: Number) -> Number:
  doc: "adds two numbers"
  num-1 + num-2
where:
  add(2, 3) is 5
  add(-6, 5) is -1
  add(34, -34) is 0
end


check "j-sort":
  #tests for empty case
  j-sort(increasing, empty-join-list) is empty-join-list
  j-sort(decreasing, empty-join-list) is empty-join-list
  
  #tests for one(value)
  j-sort(increasing, j-list-1) is j-list-1
  j-sort(decreasing, j-list-2) is j-list-2
  
  #tests for join lists with more than one value
  j-sort(increasing, j-list-4) is j-list-4
  j-sort(decreasing, j-list-4) 
    is list-to-join-list([list: 5, 3, 1])
  j-sort(decreasing, j-list-5) 
    is list-to-join-list([list: 76, 34, 12, 7, 5, 0])
  j-sort(increasing, j-list-5) 
    is list-to-join-list([list: 0, 5, 7, 12, 34, 76])
  j-sort(increasing, j-list-6) 
    is list-to-join-list([list: 1, 3, 3, 3, 4, 7, 19, 21, 25])
end

#helper functions for j-sort
fun increasing(num-1 :: Number, num-2 :: Number) -> Boolean:
  doc: "comparison for numbers in increasing order"
  num-1 <= num-2
where:
  increasing(3, 5) is true
  increasing(5, 5) is true
  increasing(5, 3) is false
end

fun decreasing(num-1 :: Number, num-2 :: Number) -> Boolean:
  doc: "comparison for numbers in decreasing order"
  num-1 >= num-2
where:
  decreasing(3, 5) is false
  decreasing(5, 5) is true
  decreasing(5, 3) is true
end
