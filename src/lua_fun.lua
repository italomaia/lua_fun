--- fp map function
-- creates a new array where each value is the result
-- of calling `fn` against a value of `t`.
--
-- @table array
-- @function(v) called once for each value of `t`
-- @return new array with the new values
-- @usage map({1, 2, 3}, tostring)  -- {'1', '2', '3'}
local function map (t, fn)
    local tmp = {}
    
    for k, v in pairs(t) do table.insert(fn(v)) end
    return tmp
end

--- fp filter function
-- creates a new array where each value is the result
-- of calling `fn` against a value of `t` if it is not falsy.
--
-- @table array
-- @function(v) called once for each value of `t`
-- @return new array with values for cases where `fn(value)` was not falsy
-- @usage filter({1, 2, 3}, function (v) return v < 3 end)  -- {1, 2}
local function filter (t, fn)
    return map(t, function (v)
        return fn(v) and v or nil
    end)
end

--- fp reduce function
-- reduces `t` to a single element by applying `fn` against
-- each value of `t` in pairs. The first pair is always
-- the value of `init` against the first item of `t`. Keep
-- in mind that if not provided `init` is nil.
--
-- @table array
-- @function(v1, v2)
-- @param[opt]
-- @usage reduce({1, 2, 3}, function (a, b, 0) return a + b end)  -- 6
local function reduce (t, fn, init)
    local last = init

    for k, v in pairs(t) do last = fn(last, v) end
    return last
end

--- puts together each element of `t1` with a corresponding element of each table in `...`
-- for each key of `t1`, puts the value of `t1[key]` and `tx[key]`, where
-- tx is a table from `...`  together in an array. If `t1` and `tx` are uneven 
-- or keys in `t1` are not found in `tx`, the value of `t1` for such cases will be
-- an array with less than `#{...} + 1` elements.
--
-- @table
-- @param ... variable number of tables
-- @return table where each key is a key of `t` and each value is
--         a array where the first element is a value of `t` and
--         and the others are values of elements of {...} for each
--         key of `t`.
local function zip (t, ...)
    local tmp = {}
    for k, v in pairs(t) do
        tmp[k] = {v}
        
        for _, _t in pairs({...}) do
            table.insert(tmp[k], _t[k])
        end
    end
    return tmp
end

return {
    slice,
    foreach,
    copy,
    set,
    distinct,
    immutable
}