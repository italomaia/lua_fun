describe('call output is as expected', function ()
  local call = require('lua_fun').call

  it('executes function without arguments', function ()
    assert.is_equal(call(function() return 1 end), 1)
  end)

  it('executes function with arguments', function ()
    assert.is_equal(call(function(a, b, c) return a + b + c end, 1, 1, 1), 3)
  end)
end)

describe('compose output is as expected', function ()
  local compose = require('lua_fun').compose

  it('fn_b is called before fn_a', function ()
    local fn = compose(
      function (v) return v .. 'a' end,
      function (v) v = v or ''; return v end
    )
    assert.is_equal(fn(), 'a')
    assert.is_equal(fn('b'), 'ba')
  end)
end)

describe('filter output is as expected', function ()
  local filter = require('lua_fun').filter
  local totable = require('lua_fun').totable
  local t = {1, 2, 3, 4, 5, 6}

  it('keeps items in condition', function ()
    local rs = filter(function (v) return true end, t)
    local rsa = totable(rs)

    assert.are.same(rsa, t)
  end)

  it('removes items not in condition', function ()
    local rs = filter(function (v) return v % 2 == 0 end, t)
    local rsa = totable(rs)

    assert.are.same(rsa, {2, 4, 6})
  end)

  it('can be chained', function ()
    local fn1 = function (v) return v % 2 == 0 end
    local fn2 = function (v) return v % 4 == 0 end
    local rs = filter(fn2, filter(fn1, { 2, 3, 4 }))
    local rsa = totable(rs)

    assert.are.same(rsa, { 4 })
  end)
end)

describe('keys output is as expected', function ()
  local keys = require('lua_fun').keys

  it('creates an generator for array with keys', function ()
    local tmp = {}
    local t = {2, 3, 4}
    local t_k = {1, 2, 3}

    for k in keys(t) do
      table.insert(tmp, k)
    end

    table.sort(tmp)
    assert.are.same(tmp, t_k)
  end)

  it('creates an generator for table with keys', function ()
    local tmp = {}
    local t = {a=2, b=3, c=4}
    local t_k = {'a', 'b', 'c'}

    for k in keys(t) do
      table.insert(tmp, k)
    end

    table.sort(tmp)
    assert.are.same(tmp, t_k)
  end)
end)

describe('values output is as expected', function ()
  local values = require('lua_fun').values

  it('creates an generator for array with keys', function ()
    local tmp = {}
    local t = {2, 3, 4}
    local t_k = {2, 3, 4}

    for v in values(t) do
      table.insert(tmp, v)
    end

    table.sort(tmp)
    assert.are.same(tmp, t_k)
  end)

  it('creates an generator for table with keys', function ()
    local tmp = {}
    local t = {a=2, b=3, c=4}
    local t_k = {2, 3, 4}

    for v in values(t) do
      table.insert(tmp, v)
    end

    table.sort(tmp)
    assert.are.same(tmp, t_k)
  end)
end)

describe('generator output is as expected', function ()
  local generator = require('lua_fun').generator

  it('creates an generator for array with keys', function ()
    local tmp = {}
    local t = {2, 3, 4}
    local t_k = {1, 2, 3}

    for k, v in generator(t) do
      table.insert(tmp, k)
    end

    table.sort(tmp)
    assert.are.same(tmp, t_k)
  end)

  it('creates an generator for table with keys', function ()
    local tmp = {}
    local t = {a=2, b=3, c=4}
    local t_k = {'a', 'b', 'c'}

    for k, v in generator(t) do
      table.insert(tmp, k)
    end

    table.sort(tmp)
    assert.are.same(tmp, t_k)
  end)

  it('creates an generator for array with values', function ()
    local tmp = {}
    local t = {2, 3, 4}
    local t_k = {2, 3, 4}

    for k, v in generator(t) do
      table.insert(tmp, v)
    end

    table.sort(tmp)
    assert.are.same(tmp, t_k)
  end)

  it('creates an generator for table with values', function ()
    local tmp = {}
    local t = {a=2, b=3, c=4}
    local t_k = {2, 3, 4}

    for k, v in generator(t) do
      table.insert(tmp, v)
    end

    table.sort(tmp)
    assert.are.same(tmp, t_k)
  end)

end)

describe('get output is as expected', function ()
  local get = require('lua_fun').get

  it('gets the value by index', function ()
    local t = {2, 4, 6}
    assert.are.equal(get(3, t), 6)
  end)
end)

describe('map output is as expected', function ()
  local call = require('lua_fun').call
  local map = require('lua_fun').map
  local totable = require('lua_fun').totable

  it('returns generator', function ()
    local count = 0
    local rs = map(function(v)
      count = count + 1
      return v
    end, {2, 3, 4})

    assert.are.equal(type(rs), "function")
    assert.is_equal(count, 0)

    local rsa = totable(rs)
    assert.is_equal(count, 3)
  end)

  it('applies to every item', function ()
    local rs = map(function (v) return v*2 end, {2, 3, 4})
    local rsa = totable(rs)

    assert.are.same(rsa, {4, 6, 8})
    assert.is_equal(#rsa, 3)
  end)

  it('works with std library', function ()
    local rs = map(tostring, {2, 3, 4})
    local rsa = totable(rs)

    assert.are.same(rsa, {'2', '3', '4'})
  end)

  it('can be chained', function ()
      local fn = function (v) return v + 1 end
      local rs = map(fn, map(fn, { 2, 3, 4 }))
      local rsa = totable(rs)

      assert.are.same(rsa, { 4, 5, 6 })
  end)
end)

describe('memoize output is as expected', function ()
  local memoize = require('lua_fun').memoize

  it("short circuits the call", function ()
    local count = 0
    local fn = memoize(function () count = count + 1; return count end)
    fn(); fn()
    assert.are.equal(count, 1)
  end)

  it("doesn't cache if return value is nil", function ()
    local count = 0
    local fn = memoize(function () count = count + 1 end)
    fn(); fn()
    assert.are.equal(count, 2)
  end)
end)

describe('reduce output is as expected', function ()
  local reduce = require('lua_fun').reduce

  it('reduces to single value', function ()
      assert.is_equal(reduce(math.min, {10, 8, 4}), 4)
  end)

  it('uses initial value', function ()
      assert.is_equal(reduce(math.min, {10, 8, 4}, 1), 1)
  end)

  it('returns initial value if array is empty', function ()
      assert.is_equal(reduce(math.min, {}, 5), 5)
  end)

  it('returns nil if array is empty', function ()
      assert.is_nil(reduce(math.min, {}), nil)
  end)
end)

describe('totable output is as expected', function ()
  local totable = require('lua_fun').totable
  local generator = require('lua_fun').generator
  local values = require('lua_fun').values

  it('parses single value generator to array', function ()
    local t1 = {2, 3, 4}
    local t2 = {'a', 'b', 'c'}
    local gen1 = values(t1)
    local gen2 = values(t2)

    assert.are.same(totable(gen1), t1)
    assert.are.same(totable(gen2), t2)
  end)

  it('parses two values generator to table', function ()
    local t1 = {2, 3, 4}
    local t2 = {a=2, b=3, c=4}
    local gen1 = generator(t1)
    local gen2 = generator(t2)

    assert.are.same(totable(gen1), t1)
    assert.are.same(totable(gen2), t2)
  end)

  it('raises error if param is not function', function ()
    assert.has_error(function () totable({}) end)
  end)
end)

describe('zip output is as expected', function ()
  local zip = require('lua_fun').zip

  it('iterates over multiple tables at once', function ()
    local tmp = {}

    for a, b in zip({'a', 'b', 'c'}, {2, 4, 6}) do
      table.insert(tmp, {a, b})
    end

    assert.are.same(tmp, {
      {'a', 2},
      {'b', 4},
      {'c', 6},
    })
  end)
end)

describe('pick output is as expected', function ()
  local pick = require('lua_fun').pick
  local partial = require('lua_fun').partial

  it('picks the nth arg', function ()
    local fn = function () return 2, 4, 6 end
    assert.is_equal(pick(2, fn()), 4)
  end)

  it('out-of-index is nil', function ()
    local forth = partial(pick, 4)
    local fn = function () return 2, 4, 6 end

    assert.is_equal(forth(fn()), nil)
  end)
end)

describe('partial output is as expected', function ()
  local partial = require('lua_fun').partial
  local pick = require('lua_fun').pick

  it('returns the nthith value', function ()
    local second = partial(pick, 2)
    local fn = function () return 2, 4, 6 end

    assert.is_equal(second(fn()), 4)
  end)
end)

describe('flip output is as expected', function ()
  local flip = require('lua_fun').flip

  it('returns a new function', function ()
    local hello = function () return "hi" end

    assert.are.equal(type(flip(hello)), 'function')
    assert.are_not.equal(flip(hello), hello)
  end)

  it('works with functions without arguments', function ()
    local hello = function () return "Hello!" end

    assert.are.equal(hello(), flip(hello)())
  end)

  it('inverts argument order', function ()
    local hello = function (name, greeting)
      return greeting .. ' ' .. name
    end

    assert.are.equal(hello("italo", "hi"), flip(hello)("hi", "italo"))
  end)
end)


describe('factory output is as expected', function ()
  local factory = require('lua_fun').factory
  local totable = require('lua_fun').totable
  local pick = require('lua_fun').pick

  it('creates a new function', function ()
    assert.are.equal(type(factory(function() end)), 'function')
  end)

  it('condition is optional', function ()
    local fn = factory(function() end)

    assert.is_nil(pick(2, fn()))
    assert.is_nil(pick(2, fn()))
    assert.is_nil(pick(2, fn()))
  end)

  it('each call receives the last value of the call', function ()
    local fn = factory(function(_, v)
      if v == nil then return 1 end
      return v + 2
    end)

    assert.are.same({1, 1}, {fn()})
    assert.are.same({2, 3}, {fn()})
    assert.are.same({3, 5}, {fn()})
  end)

  it('stop condition is inclusive', function ()
    local fn = factory(
      function (i) return i end,
      function (i) return i <= 5 end
    )

    assert.are.same({1, 2, 3, 4, 5}, totable(fn))
  end)

  it('initial value sets first iteration value', function ()
    local fn = factory(
      function (_, v) return v + 1 end,
      function (_, v) return v <= 5 end,
      2
    )

    assert.are.same({3, 4, 5}, totable(fn))
  end)

  it('has 1 as first index of the iteration', function ()
    local fn = factory(function () end)

    assert.are.same(fn(), 1)
  end)

  it('has nil as first value of the iteration if init is not provided', function ()
    local fn = factory(function (_, v) return v end)

    assert.is_nil(pick(2, fn()))
  end)
end)

describe('lambda output is as expected', function ()
  local lambda = require('lua_fun').lambda

  it('creates a new function', function()
    assert.are.equal(type(lambda('|| 5')), 'function')
  end)

  it("doesn't need arguments", function()
    assert.are.equal(lambda('|| 5')(), 5)
  end)

  it("doesn't have access to outer scope", function()
    local outer = 10
    assert.are.equal(lambda('|| outer')(), nil)
  end)

  it("accepts one parameter", function()
    assert.are.equal(lambda('|x| x')(4), 4)
  end)

  it("accepts multiple parameters", function()
    assert.are.equal(lambda('|x, y| x + y')(3, 4), 7)
  end)
end)
