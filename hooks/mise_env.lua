local function path_sep()
    return package.config:sub(1, 1) == "\\" and ";" or ":"
end

function PLUGIN:MiseEnv(ctx)
    local cmd = require("cmd")
    local log = require("log")

    local dirs = {}
    local seen = {}
    local sep = path_sep()

    local out = cmd.exec("mise bin-paths")

    for line in out:gmatch("[^\r\n]+") do
        -- /Users/.../.local/share/mise/installs/helm-plugin-databus23-helm-diff/3.15.10/bin
        local install_dir = line:match("^(.*[/\\]installs[/\\]helm%-plugin%-[^/\\]+[/\\][^/\\]+[/\\]bin)$")
        log.debug("Found install_dir: " .. tostring(install_dir))

        if install_dir and not seen[install_dir] then
            seen[install_dir] = true
            table.insert(dirs, install_dir)
        end
    end

    if #dirs == 0 then
        return {}
    end

    return {
        {
            key = "HELM_PLUGINS",
            value = table.concat(dirs, sep),
        },
    }
end
