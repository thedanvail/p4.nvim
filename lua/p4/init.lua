if vim.fn.executable('p4') ~= 1 then
    return {}
end

local cl = require('p4.changelist')
local config = require('p4.config')

local M = {}

print(cl.getClient())
