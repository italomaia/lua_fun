describe('toarray output is as expected', function ()
  local toarray = require('lua_fun').toarray

  it('parses generator to array', function ()
    local count = 0
    local gen = function ()
      if count < 3 then
        count = count + 1
        return count
      end
    end

    assert.are.same(toarray(gen), {1, 2, 3})
  end)

  it('raises error if param is not function', function ()
    assert.has_error(function () toarray({}) end)
  end)
end)

describe('generator output is as expected', function ()
  local generator = require('lua_fun').generator
  
  it('creates an generator for table', function ()
    local tmp = {}
    local t = {2, 3, 4}
    
    for v in generator(t) do
      table.insert(tmp, v)
    end
    
    assert.are.same(tmp, t)
  end)
end)

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

describe('map output is as expected', function ()
  local call = require('lua_fun').call
  local map = require('lua_fun').map
  local toarray = require('lua_fun').toarray

  it('returns generator', function ()
    local count = 0
    local rs = map(function(v)
      count = count + 1
      return v
    end, {2, 3, 4})

    assert.are.equal(type(rs), "function")
    assert.is_equal(count, 0)

    local rsa = toarray(rs)
    assert.is_equal(count, 3)
  end)

  it('applies to every item', function ()
    local rs = map(function (v) return v*2 end, {2, 3, 4})
    local rsa = toarray(rs)

    assert.are.same(rsa, {4, 6, 8})
    assert.is_equal(#rsa, 3)
  end)

  it('works with std library', function ()
    local rs = map(tostring, {2, 3, 4})
    local rsa = toarray(rs)

    assert.are.same(rsa, {'2', '3', '4'})
  end)

  it('can be chained', function ()
      local fn = function (v) return v + 1 end
      local rs = map(fn, map(fn, { 2, 3, 4 }))
      local rsa = toarray(rs)

      assert.are.same(rsa, { 4, 5, 6 })
  end)
end)

describe('filter output is as expected', function ()
  local filter = require('lua_fun').filter
  local toarray = require('lua_fun').toarray
  local t = {1, 2, 3, 4, 5, 6}

  it('keeps items in condition', function ()
      local rs = filter(function (v) return true end, t)
      local rsa = toarray(rs)
      
      assert.are.same(rsa, t)
  end)

  it('removes items not in condition', function ()
      local rs = filter(function (v) return v % 2 == 0 end, t)
      local rsa = toarray(rs)
      
      assert.are.same(rsa, {2, 4, 6})
  end)

  it('can be chained', function ()
      local fn1 = function (v) return v % 2 == 0 end
      local fn2 = function (v) return v % 4 == 0 end
      local rs = filter(fn2, filter(fn1, { 2, 3, 4 }))
      local rsa = toarray(rs)

      assert.are.same(rsa, { 4 })
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

describe('pick output is as expected', function () end)
describe('partial output is as expected', function () end)
