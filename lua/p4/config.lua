local path = require('plenary.path')

local M = {}

M.loadConfig = function()
    local configFile = vim.fn.stdpath('data') .. "/.p4nvim.json"
    if io.open(configFile, "r") ~= nil then
        return vim.fn.json_decode(path:new(configFile):read())
    end
    return nil
end

M.writeConfig = function(config)
    local configFile = vim.fn.stdpath('data') .. "/.p4nvim.json"
    if io.open(configFile, "r") ~= nil then
        path:new(configFile):write(vim.fn.json_encode(config), "w")
    end
end

M.addToConfig = function()
end

M.getConfig = function()
    return M.config
end

return M
