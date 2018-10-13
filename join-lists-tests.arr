import j-max,
       j-first,
       j-rest,
       j-length,
       j-nth,
       j-map,
       j-filter,
       j-sort,
       j-reduce
  from my-gdrive("joinlists-code.arr")

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

a=join-list(one(5), one(6), 2)
b=join-list(one(4), one(7), 2)
c=join-list(a, b, 4)
d=join-list(b, a, 4)
e=join-list(empty-join-list, one(7), 2)

check "j-first":
  #The following is a general test for j-first
  j-first(list-to-join-list([list: 1, 3, 5])) is 1
  #The following are tests for constructed join-lists
  j-first(c) is 5
  j-first(d) is 4
end

check "j-rest":
  #The following are general tests for j-rest
  j-rest(list-to-join-list([list: 1, 3, 5])) is list-to-join-list([list: 3, 5])
  j-rest(c) is list-to-join-list([list: 6, 4, 7])
end

check "j-length":
  #The following are general tests for j-length
  j-length(list-to-join-list([list: 1, 3, 5])) is 3
  j-length(a) is 2
  j-length(c) is 4
  j-length(empty-join-list) is 0 #Tests the empty case
end

check "j-nth":
  #The following are general tests for j-nth
  j-nth(list-to-join-list([list: 1, 3, 5]), 2) is 5
  j-nth(list-to-join-list([list: 1, 3, 5]), 1) is 3
  j-nth(a, 1) is 6
  j-nth(b, 0) is 4
  j-nth(c, 2) is 4
  j-nth(d, 1) is 7
end

check "j-max":
  #The following are general tests for j-max
  j-max(list-to-join-list([list: 1, 3, 5]), _greaterthan) is 5
  j-max(a, _greaterthan) is 6
  j-max(b, _greaterthan) is 7
  j-max(c, _greaterthan) is 7
end

fun doubler(a-num :: Number) -> Number:
  doc: "For use in j-map"
  a-num * 2
end

check "j-map":
  #The following are general tests for j-max
  j-map(doubler, a) is list-to-join-list([list: 10, 12])
  j-map(doubler, c) is list-to-join-list([list: 10, 12, 8, 14])
  j-map(doubler, list-to-join-list([list: 1, 3, 5, 7]))
    is list-to-join-list([list: 2, 6, 10, 14])
  j-map(doubler, empty-join-list) is empty-join-list #Tests the empty case
end

fun is-even(a-num :: Number) -> Boolean:
  doc: "For use in j-filter"
  if num-modulo(a-num, 2) == 1:
    false
  else:
    true
  end
end

check "j-filter":
  #The following are simple checks for j-filter
  j-filter(is-even, one(5)) is empty-join-list
  j-filter(is-even, a) is one(6)
  j-filter(is-even, b) is one(4)
  j-filter(is-even, c) is list-to-join-list([list: 6, 4])
  j-filter(is-even, d) is list-to-join-list([list: 4, 6])
  j-filter(is-even, empty-join-list) is empty-join-list #Tests the empty case
end

fun mult(num-1 :: Number, num-2 :: Number) -> Number:
  doc: "For use in j-reduce"
  num-1 * num-2
end

fun add(num-1 :: Number, num-2 :: Number) -> Number:
  doc: "For use in j-reduce"
  num-1 + num-2
end

check "j-reduce":
  #Simple checks for j-reduce
  j-reduce(mult, a) is 30
  j-reduce(mult, b) is 28
  j-reduce(mult, c) is 840
  j-reduce(mult, d) is 840
  j-reduce(add, c) is 22
end

fun increasing(num-1 :: Number, num-2 :: Number) -> Boolean:
  doc: "For use in j-sort"
  if num-1 <= num-2:
    true
  else:
    false
  end
end

fun decreasing(num-1 :: Number, num-2 :: Number) -> Boolean:
  doc: "For use in j-sort"
  if num-1 >= num-2:
    true
  else:
    false
  end
end

check "j-sort":
  #Simple checks for j-sort
  j-sort(increasing, a) is a
  j-sort(decreasing, a) is join-list(one(6), one(5), 2)
  j-sort(increasing, b) is b
  j-sort(decreasing, b) is join-list(one(7), one(4), 2)
  j-sort(increasing, d) is list-to-join-list([list: 4, 5, 6, 7])
  j-sort(decreasing, d) is list-to-join-list([list: 7, 6, 5, 4])
  j-sort(increasing, empty-join-list) is empty-join-list #Tests the empty case
  j-sort(decreasing, empty-join-list) is empty-join-list #Tests the empty case
end
