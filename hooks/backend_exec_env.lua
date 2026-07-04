--- Helm plugins are managed by helm itself, no extra env vars needed.

--- @param ctx {install_path: string, tool: string, version: string} Context
--- @return {env_vars: table[]} Table containing list of environment variable definitions
function PLUGIN:BackendExecEnv(ctx)
    return {
        env_vars = {},
    }
end
