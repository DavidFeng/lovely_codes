-- http://tinylittlelife.org/?p=249
-- curry(func, num_args) : take a function requiring a tuple for num_args arguments
--              and turn it into a series of 1-argument functions
-- e.g.: you have a function dosomething(a, b, c)
--       curried_dosomething = curry(dosomething, 3) -- we want to curry 3 arguments
--       curried_dosomething (a1) (b1) (c1)  -- returns the result of dosomething(a1, b1, c1)
--       partial_dosomething1 = curried_dosomething (a_value) -- returns a function
--       partial_dosomething2 = partial_dosomething1 (b_value) -- returns a function
--       partial_dosomething2 (c_value) -- returns the result of dosomething(a_value, b_value, c_value)
function curry(func, num_args)

   -- currying 2-argument functions seems to be the most popular application
   num_args = num_args or 2

   -- helper
   local function curry_h(argtrace, n)
      if 0 == n then
         -- reverse argument list and call function
         return func(reverse(argtrace()))
      else
         -- "push" argument (by building a wrapper function) and decrement n
         return function (onearg)
                   return curry_h(function ()
                       return onearg, argtrace()
                   end, n - 1)
                end
      end
   end

   -- no sense currying for 1 arg or less
   if num_args > 1 then
      return curry_h(function () return end, num_args)
   else
      return func
   end
end

-- reverse(...) : take some tuple and return a tuple of elements in reverse order
--
-- e.g. "reverse(1,2,3)" returns 3,2,1
function reverse(...)

   --reverse args by building a function to do it, similar to the unpack() example
   local function reverse_h(acc, v, ...)
      if 0 == select('#', ...) then
         return v, acc()
      else
         return reverse_h(function () return v, acc() end, ...)
      end
   end

   -- initial acc is the end of the list
   return reverse_h(function () return end, ...)
end



local function test()
    local f = function(a, b, c)
        return a + b + c
    end
    local cf = curry(f, 3)
    print(cf(1)(2)(3)) -- 6
    print(cf(1)(2))    -- function
end
test()
