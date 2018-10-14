# CSCI0190 (Fall 2018)
provide *

import shared-gdrive("join-lists-support.arr",
  "1OH25NKkXAwcOtXs9yGLAjZO3u65T6T0J") as J

# Imports below

# Imports above

type JoinList = J.JoinList
empty-join-list = J.empty-join-list
one = J.one
join-list = J.join-list

split = J.split
join-list-to-list = J.join-list-to-list
list-to-join-list = J.list-to-join-list
is-non-empty-jl = J.is-non-empty-jl

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

##Implementation
fun j-first<A>(jl :: JoinList<A>%(is-non-empty-jl)) -> A:
  doc:"Returns the first element of a non-empty join-list j1"
  cases(JoinList) jl:
      #the predicate should ensure that j1 is not an empty-join-list,
      #but include error just in case
    | empty-join-list => raise("Cannot compute on empty-join-list")
      #first element in a join-list of one is the first
    | one(val) => val
    | join-list(l1, l2, len) => 
      #compute j-first on the pref returned by split using helper function
      split(
        jl,
        j-first-split-help)
  end   
where:
  #j-first on one(val)
  j-first(j-list-1) is 4
  j-first(j-list-2) is 8
  
  #j-first on j-list with more than one element
  j-first(j-list-3) is 3
  j-first(j-list-5) is 76
end

#helper function for j-first
fun j-first-split-help<A>(pref :: JoinList<A>%(is-non-empty-jl), 
    suf :: JoinList<A>%(is-non-empty-jl)) -> A:
  doc:```returns the j-first of pref, contains two parameters to match split's
  signature requirements```
  j-first(pref)
where:
  #both lists are one(val)
  j-first-split-help(j-list-1, j-list-2) is 4
  #first list is one(val)
  j-first-split-help(j-list-2, j-list-4) is 8
  #first list is join-list(l1, l2, len)
  j-first-split-help(j-list-4, j-list-2) is 1
  #both lists are join-list(l1, l2, len)
  j-first-split-help(j-list-5, j-list-6) is 76
end


fun j-rest<A>(jl :: JoinList<A>%(is-non-empty-jl)) -> JoinList<A>:
  doc:"Returns the join-list of every element in j1 except the first"
  cases(JoinList) jl:
      #the predicate should ensure that j1 is not an empty-join-list,
      #but include error just in case
    | empty-join-list => raise("Cannot compute on empty join-list")
      #rest of a join-list with one element is an empty-join-list
    | one(val) => empty-join-list
    | join-list(l1, l2, len) => 
      #compute rest of j1 using helper function
      split(
        jl,
        j-rest-split-help)
  end 
where:
  #j-rest on list with one element
  j-rest(j-list-1) is empty-join-list
  j-rest(j-list-2) is empty-join-list
  
  #j-rest on j-list with more than one element
  j-rest(j-list-3) is list-to-join-list([list: 2])
  j-rest(j-list-4) is list-to-join-list([list: 3, 5])
  j-rest(j-list-5) is list-to-join-list([list: 34, 5, 12, 0, 7])
end

#helper function for j-rest
fun j-rest-split-help<A>(pref :: JoinList<A>%(is-non-empty-jl), 
    suf :: JoinList<A>%(is-non-empty-jl)) -> JoinList<A>:
  doc:"returns rest of pref appended to suf"
  cases (JoinList) pref:
      #the predicate should ensure that pref is not an empty-join-list,
      #but include error just in case
    | empty-join-list => raise("Cannot compute on empty-join-list")
      #if pref only has one val, rest is just the suf
    | one(val) => suf
    | join-list(l1, l2, len) => 
      #append rest of pref with suf
      j-rest(pref).join(suf)
  end
where:
  #both lists are one(val)
  j-rest-split-help(j-list-1, j-list-2) is one(8)
  #first list is one(val)
  j-rest-split-help(j-list-2, j-list-4) is j-list-4
  #first list is join-list(l1, l2, len)
  j-rest-split-help(j-list-4, j-list-2) 
    is list-to-join-list([list: 3, 5, 8])
  #both lists are join-list(l1, l2, len)
  j-rest-split-help(j-list-5, j-list-6) 
    is list-to-join-list([list: 34, 5, 12, 0, 7, 3, 4, 25, 3, 1, 7, 19, 21, 3])
end
  
fun j-length<A>(jl :: JoinList<A>) -> Number:
  doc:"returns the number of elements in jl"
  cases (JoinList) jl:
      #empty-join-list has 0 elements
    | empty-join-list => 0
      #if jl is one(val), has 1 element
    | one(val) => 1
    | join-list(l1, l2, len) => 
      #if jl has more than one val, add lengths of its pre and suf
      split(
        jl,
        #lambda function adds together the lengths of prefix and suffix
        lam(x, y) -> Number: j-length(x) + j-length(y) end)
  end
where:
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

fun j-nth<A>(jl :: JoinList<A>%(is-non-empty-jl),
    n :: Number) -> A:
  doc:"Returns the nth element of jl"
  cases (JoinList) jl:
      #the predicate should ensure that pref is not an empty-join-list,
      #but include error just in case
    | empty-join-list => raise("Cannot compute on empty join-list")
    | one(val) => 
      #if jl is one(val), only return value if n is 0, else raise error
      if n == 0:
        val
      else:
        raise("Index error")
      end
    | join-list(l1, l2, len) =>  
      if n == 0:
        #if n = zero, return first element
        j-first(jl) 
      else:
        #find the n-1th element on rest of list
        j-nth(j-rest(jl), n - 1)
      end
  end
where:
  #j-nth on one(value)
  j-nth(j-list-1, 0) is 4
  j-nth(j-list-2, 0) is 8
  
  #j-nth on jlist with more than one element
  j-nth(j-list-3, 0) is 3
  j-nth(j-list-3, 1) is 2
  j-nth(j-list-5, 3) is 12
  j-nth(j-list-6, 6) is 19
end

fun j-max<A>(jl :: JoinList<A>%(is-non-empty-jl), 
    cmp :: (A, A -> Boolean)) -> A:
  doc:"Find the max value of jl as defined by cmp"
  cases (JoinList) jl:
      #the predicate should ensure that pref is not an empty-join-list,
      #but include error just in case
    | empty-join-list => raise("Cannot compute on empty join-list")
      #if jl is one(val), it is the maximum element
    | one(val) => val
    | join-list(l1, l2, len) =>  
      split(
        jl,
        #lambda function returns larger of j-max(pref) and j-max(suf)
        #as defined by cmp
        lam(pref :: JoinList<A>%(is-non-empty-jl), 
            suf :: JoinList<A>%(is-non-empty-jl))
          -> A:
          if cmp(j-max(pref, cmp), j-max(suf, cmp)):
            #if the largest of pref > largest of suf, find largest of pref
            j-max(pref, cmp)
          else:
            #else return largest of suf
            j-max(suf, cmp)
          end
        end)
  end
where:
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

fun j-map<A,B>(map-fun :: (A -> B), jl :: JoinList<A>) -> JoinList<B>:
  doc:"Applies the function map-fun to every element in jl"
  cases(JoinList) jl:
      #if already empty-join-list, leave as is
    | empty-join-list => empty-join-list
      #if one value, apply function to value and return it
    | one(val) => one(map-fun(val))
    | join-list(l1, l2, len) => 
      split(
        jl,
        #lambda function joins two split lists together after applyinh
        #j-map to both prefix and suffix
        lam(pref :: JoinList<A>, suf :: JoinList<A>)
          -> JoinList<A>:
          j-map(map-fun, pref).join(j-map(map-fun, suf))
        end)
  end
where:
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

fun j-filter<A>(filter-fun :: (A -> Boolean), jl :: JoinList<A>) -> JoinList<A>:
  doc:"Filters out any elements that return false for filter-fun in jl"
  cases(JoinList) jl:
      #if already empty-join-list, leave as is
    | empty-join-list => empty-join-list
      #if one value, apply function to value and return it
    | one(val) => 
      if filter-fun(val):
        #leave one(val) as is if it passes filter-fun
        one(val)
      else:
        #change to empty-jl if val doesnt pass filter-fun
        empty-join-list
      end
    | join-list(l1, l2, len) => 
      split(
        jl,
        #lambda function joins two split lists together after applying
        #j-filter to both prefix and suffix
        lam(pref :: JoinList<A>, suf :: JoinList<A>)
          -> JoinList<A>:
          j-filter(filter-fun, pref).join(j-filter(filter-fun, suf))
        end)
  end
where:
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


fun j-reduce<A>(reduce-func :: (A, A -> A), 
    jl :: JoinList<A>%(is-non-empty-jl)) -> A:
  doc:"Distributes an operator reduce-func across every element in jl"
  cases(JoinList) jl:
      #if already empty-join-list, leave as is
    | empty-join-list => empty-join-list
      #if one value, we have successfully reduced jl, return one(val)
    | one(val) => val
    | join-list(l1, l2, len) => 
      split(
        jl,
        #lambda function applies reduce-func to the two
        #split lists after being reduced themselves
        lam(pref :: JoinList<A>, suf :: JoinList<A>)
          -> A:
          reduce-func(
            j-reduce(reduce-func, pref), 
            j-reduce(reduce-func, suf))
        end)
  end
where:
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
  doc: "multiplies two numbers"
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

fun j-sort<A>(cmp-fun :: (A, A -> Boolean), jl :: JoinList<A>) -> JoinList<A>:
  doc:```sorts jl according to the comparison function cmp-fun,
  where cmp-fun(some val, next val) returns true in sorted list```
  cases(JoinList) jl:
      #if already empty-join-list, list is sorted, return it
    | empty-join-list => empty-join-list
      #if one value, we have successfully sorted jl, return one(val)
    | one(val) => one(val)
    | join-list(l1, l2, len) => 
      split(
        jl,
        #lambda function applies sort to prefix and suffix and uses
        #helper function merge them together
        lam(pref :: JoinList<A>, suf :: JoinList<A>)
          -> JoinList<A>:
          j-sort-merger(
            cmp-fun,
            j-sort(cmp-fun, pref), 
            j-sort(cmp-fun, suf))
        end)
  end
where:
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

fun j-sort-merger<A>(cmp-fun :: (A, A -> Boolean),
    sl1 :: JoinList<A>, sl2 :: JoinList<A>) -> JoinList<A>:
  doc:"merges two sorted lists, sl1 and sl2, together using cmp-fun"
  cases(JoinList) sl1:
      #if sl1 is already sorted, return sl2, no matter what it is
    | empty-join-list => sl2
      #if one value, check against first of sl2
    | one(val1) => 
      cases(JoinList) sl2:
          #if sl2 empty, sorted list is just one(val1)
        | empty-join-list => one(val1)
          #if both sl1 and sl2 ones, sort them according to cmp-fun
        | one(val2) => 
          if cmp-fun(val1, val2):
            one(val1).join(one(val2))
          else:
            one(val2).join(one(val1))
          end
          #if sl2 join list, join two lists if cmp-fun(val1, first(sl2))
          #returns true, recur on rest of sl2 if false
        | join-list(l3, l4, len2) => 
          firstsl2 = j-first(sl2)
          if cmp-fun(val1, firstsl2):
            #if val1 is first val, entire sl2 goes after
            one(val1).join(sl2)
          else:
            #if val1 not first, join firstsl2 to sort-merger on rest of sl2
            one(firstsl2).join(j-sort-merger(cmp-fun, one(val1), j-rest(sl2)))
          end
      end
    | join-list(l1, l2, len) => 
      cases(JoinList) sl2:
          #if sl2 empty, sorted list is just sl1
        | empty-join-list => sl1
          #if sl2 one, join two lists if cmp-fun(val1, first(sl2))
          #returns true, recur on rest of sl2 if false
        | one(val2) => 
          firstsl1 = j-first(sl1)
          if cmp-fun(val2, firstsl1):
            #if val2 is first val, entire sl1 goes after
            one(val2).join(sl1)
          else:
            #if val2 not first val, sort-merger on rest of sl1
            one(firstsl1).join(j-sort-merger(cmp-fun, j-rest(sl1), one(val2)))
          end
          #if both sl1 and sl2 join lists, compare first elements and 
          #recur accordingly
        | join-list(l3, l4, len2) => 
          firstsl1 = j-first(sl1)
          firstsl2 = j-first(sl2)
          if cmp-fun(firstsl1, firstsl2):
            #if firstsl1 first, join firstsl1 to sorted on rest of sl1 and sl2
            one(firstsl1).join(j-sort-merger(cmp-fun, j-rest(sl1), sl2))
          else:
            #if firstsl2 first, join firstsl2 to sorted on sl1 and rest of sl2
            one(firstsl2).join(j-sort-merger(cmp-fun, sl1, j-rest(sl2)))
          end
      end
  end
where:
  #both are empty
  j-sort-merger(increasing, empty-join-list, empty-join-list) 
    is empty-join-list
  
  #one list is empty, other is one(val)
  j-sort-merger(increasing, one(5), empty-join-list) 
    is one(5)
  j-sort-merger(increasing, empty-join-list,  one(3)) 
    is one(3)
  
  #both are one(val)
  j-sort-merger(increasing, one(6), one(4)) 
    is list-to-join-list([list: 4, 6])
  
  #at least one is j-list
  j-sort-merger(increasing, list-to-join-list([list: 4, 6, 7]), one(3))
    is list-to-join-list([list: 3, 4, 6, 7])
  j-sort-merger(increasing, one(6.5), list-to-join-list([list: 4, 6, 7]))
    is list-to-join-list([list: 4, 6, 6.5, 7])
  j-sort-merger(increasing, 
    list-to-join-list([list: 2, 3, 5, 8]), 
    list-to-join-list([list: 4, 6, 7]))
    is list-to-join-list([list: 2, 3, 4, 5, 6, 7, 8])
  
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
