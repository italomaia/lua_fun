*lua_fun* is a friendly library to help you get more productive with Lua.
It packs common functional programming utilities that might save you
some coding in the long run.

**compatibility:** lua5.3>=

## Why?

*lua_fun* was created because I've not found a module that makes working
with Lua and functional programming more productive without adding too much
to the stack. *lua_fun* attempts to provide just enough with good compatibility
with Lua standard modules.

## How To

```
# How To Install
luarocks install lua_fun  # install globally
luarocks install --local lua_fun  # or install locally

# How To Generate Docs
ldoc .

# How To Run Tests
busted --lua=/usr/bin/lua
```

## Getting Started

[docs](https://github.com/italomaia/lua_fun/blob/master/docs/index.html)

*lua_fun* usage is advised in one of the following ways:

```
-- per function
local L = require('lua_fun').lambda

-- as a module
local fun = require('lua_fun')
```

## Examples

```
local fun = require('lua_fun)
local l = fun.lambda
local generator = fun.generator
local totable = fun.totable
local keys = fun.keys
local values = fun.values
local call = fun.call
local compose = fun.compose
local flip = fun.flip
local get = fun.get
local pick = fun.pick
local factory = fun.factory
local map = fun.map
local filter = fun.filter
local reduce = fun.reduce
local zip = fun.zip
local partial = fun.partial
local memoize = fun.memoize

local sum = l'|a, b| a+b'
local sum2 = partial(sum, 2)
local pow2 = partial(flip(math.pow), 2)
local pow4 = compose(pow2, pow2)

assert.are.equal(sum2(3), 5)
assert.are.equal(pow2(3), 9)
assert.are.equal(pow4(2), 16)
assert.are.equal(call(sum, 3, 3), 6)
assert.are.equal(get(3, {5, 6, 7}), 7)
assert.are.equal(pick(2, table.unpack({5, 6, 7})), 6)

local function fibonacci (n)
    if n<3 then return 1 else
        return fibonacci(n-1) + fibonacci(n-2)
    end
end

fibonacci = memoize(fibonacci)  -- cached now =D

local cmp_table = function (a, b)
    for k, v in pairs(a) do
    if v ~= b[k] then return false end
    end

    for k, v in pairs(b) do
    if v ~= a[k] then return false end
    end

    return true
end

local gen, t

gen = filter(l'|v| v % 2 == 0', {1,2,3,4,5,6,7,8})
assert.are.equal(type(gen), 'function')

t = totable(gen)
assert.is_true(cmp_table(t, {2, 4, 6, 8}))

gen = map(l'|v| v * 2', t)
assert.are.equal(type(gen), 'function')

t = totable(gen)
assert.is_true(cmp_table(t, {4, 8, 12, 16}))

assert.are.equal(reduce(sum, t), 40)

local tkeys = totable(keys({a=10, b=20, c=30}))
local tvalues = totable(values({a=10, b=20, c=30}))

-- sort guaranties only for arrays
table.sort(tkeys)
table.sort(tvalues)

assert.are.same(tkeys, {'a', 'b', 'c'})
assert.are.same(tvalues, {10, 20, 30})
```