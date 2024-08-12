FILEPATH = vim.fn.getcwd() .. "/.p4nvim.json"
CLIENT = ""
CURRENT_CHANGELIST = ""
ALL_CHANGELISTS = {}

local M = {}
-- 
-- local addOrAppendToCache = function(key, val)
--     local exists = io.open(FILEPATH, "r") ~= nil
--     if exists then
--         local file = io.open(FILEPATH, "a")
--     else
--         local file = io.open(FILEPATH, "w")
--     end
--     
-- end

function M.getAllPendingChangelists(client, map)
    local output = vim.fn.system({"p4", "changes", "-c", client, "-s", "pending"})
    local cl = ""
    for s in output:gmatch("[^\r\n]+") do
        local start, _ = s:find("*pending*")
        if start ~= nil then
            cl = s:sub(8, 14)
            map[cl] = s
        end
    end
    for k, v in pairs(map) do
        print(k .. v)
    end
end

function M.getChangelists(client)
    local output = vim.fn.system({"p4", "changes", "-c", client})
    local cl = ""
    for s in output:gmatch("[^\r\n]+") do
        local start, _ = s:find("*pending*")
        if start ~= nil then
            cl = s:sub(8, 14)
            cl = cl:gsub("%s+", "")
        end
    end
    if #cl == 0 then
        print("No pending changelists.")
    end
    return cl
end

function M.createChangelist()
    local description = vim.fn.input("Changelist Description: ")
    if description == "" then return end
    local output = vim.fn.system({"p4", "--field", string.format("Description=%s", description), "change", "-o", "|", "p4", "change", "-i"})
    print(output)
end

function M.moveFileToAnotherChangelist(changelist)
    print(vim.fn.system({"p4", "reopen", "-c", changelist}))
end

function M.removeFilesFromChangelist(changelist)
    print(vim.fn.system({"p4", "revert", "-c", changelist}))
end

function M.deleteChangelist(changelist)
    if changelist == nil then
        return
    end
    local output = vim.fn.system({"p4", "change", "-d", changelist})
    print(output)
end

function M.getClient()
    local output = vim.fn.system({'p4', 'client', '-o'})
    local clientName = ""
    for s in output:gmatch("[^\r\n]+") do
        if s:find("Client:", 1, true) == 1 then
            clientName = string.sub(s, 9, s:len())
        end
    end
    return clientName
end

function M.checkout()
    local path = vim.uri_from_bufnr(0)
    local output = vim.fn.system({'p4', 'edit', '-c', CURRENT_CHANGELIST, path})
    if output ~= "" then
        print(output)
    else
        print("Could not checkout file - P4 gave no reason.")
    end
end

-- popup.create(vim.api.nvim_create_buf(false, false), {
--     title = "test",
--     highlight = "testwindow",
--     line = 30,
--     col = 70,
--     minwidth = 60,
--     minheight = 10,
--     borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
-- })

return M

