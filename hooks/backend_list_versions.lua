--- Lists available versions for a helm plugin from GitHub releases.
--- Tool format: "owner/repo" (e.g. "helm-unittest/helm-unittest")

function PLUGIN:BackendListVersions(ctx)
    local cmd = require("cmd")
    local json = require("json")

    local tool = ctx.tool
    if not tool or tool == "" then
        error("Tool name cannot be empty. Use format: owner/repo")
    end

    -- Fetch tags from GitHub API
    local url = "https://api.github.com/repos/" .. tool .. "/releases?per_page=100"
    local auth_header = ""
    local token = os.getenv("GITHUB_TOKEN")
    if token and token ~= "" then
        auth_header = ' -H "Authorization: Bearer ' .. token .. '"'
    end
    local result = cmd.exec("curl -sS" .. auth_header .. " " .. url)

    local success, releases = pcall(json.decode, result)
    if not success or not releases then
        error("Failed to fetch releases for " .. tool)
    end

    local versions = {}
    for i = #releases, 1, -1 do
        local tag = releases[i].tag_name
        if tag then
            -- Strip leading 'v' prefix if present
            local version = tag:gsub("^v", "")
            table.insert(versions, version)
        end
    end

    if #versions == 0 then
        error("No versions found for " .. tool)
    end

    return { versions = versions }
end
