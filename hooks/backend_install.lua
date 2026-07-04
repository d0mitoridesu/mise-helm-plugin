--- Installs a helm plugin into mise's install_path

local cmd = require("cmd")

local function shell_quote(s)
    return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

local function trim(s)
    return (s or ""):gsub("%s+$", "")
end

local function find_helm_bin()
    local ok, out = pcall(cmd.exec, "mise which helm")
    if ok then
        local path = trim(out)
        if path ~= "" then
            return path
        end
    end

    ok, out = pcall(cmd.exec, "command -v helm")
    if ok then
        local path = trim(out)
        if path ~= "" then
            return path
        end
    end

    error("Helm binary not found. Install helm with mise or make sure helm is in PATH.")
end

function PLUGIN:BackendInstall(ctx)
    local helm_bin = find_helm_bin()
    local helm_plugin_name = ctx.tool:match("([^/]+)$")
    local plugin_version = "v" .. ctx.version

    if helm_plugin_name == nil or helm_plugin_name == "" then
        error("Invalid tool name: " .. ctx.tool)
    end

    local verify_flag = ""
    if ctx.options and ctx.options.verify == "false" then
        verify_flag = " --verify=false"
    end

    local install_dir = ctx.install_path .. "/bin"
    local plugin_repo_uri = "https://github.com/" .. ctx.tool .. ".git"

    cmd.exec(
        "HELM_PLUGINS="
            .. shell_quote(install_dir)
            .. " "
            .. shell_quote(helm_bin)
            .. " plugin install "
            .. plugin_repo_uri
            .. " --version "
            .. plugin_version
            .. verify_flag
    )

    return {}
end
