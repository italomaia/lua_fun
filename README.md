*lua_fun* is a friendly library to help you get more productive with Lua.
It packs common functional programming utilities that might save you
some coding in the long run.

**compatibility:** lua5.3>=

## Why?

*lua_fun* was created because I've not found a module that makes working
with Lua and functional programming more productive without adding too much
to the stack. *lua_fun* attempts to provide just enough with good compatibility
with Lua standard modules.

## Install

```
luarocks install lua_fun
# or
luarocks install --local lua_fun
```

## Getting Started

[docs](https://github.com/italomaia/lua_fun/blob/master/docs/index.html)

*lua_fun* usage is advised in one of the following ways:

```
-- as a module
local fun = require('lua_fun')

-- extending the environment
require('lua_fun').patch(_G, ltable)
```

## Examples

```
local fun = require('lua_fun)

local sum = function (a, b) return a + b end
local sum2 = fun.partial(sum, 2)
local pow2 = fun.partial(fun.flip(math.pow), 2)
local pow4 = fun.compose(pow2, pow2)

assert(fun.call(sum, 2, 2) == 4)
assert(sum2(2) == 4)
assert(pow2(3) == 9)
assert(pow4(3) == 81)

local L = fun.lambda  -- little shortcut for us 
local plus_one = L'|x| x + 1'
assert(plus_one(5) == 6)

local plus_one_generator = fun.factory(L'|i,v| i')
local sub = L'|x,y| x/y'

assert(sub(1, 0), math.huge)
assert(fun.flip(sub)(1, 0), 0)

local cached_sum = fun.memoize(function(a, b) return a + b end)
```