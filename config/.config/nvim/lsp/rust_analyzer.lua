local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
end

return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },

  -- Prefer the Rust crate/workspace root instead of repo root.
  -- If your LSP framework uses `root_markers`, this is the equivalent.
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },

  capabilities = capabilities,

  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        -- If you have a workspace with multiple crates, this helps.
        -- loadOutDirsFromCheck = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      procMacro = {
        enable = true,
      },
      inlayHints = {
        bindingModeHints = { enable = true },
        chainingHints = { enable = true },
        closingBraceHints = { enable = true, minLines = 25 },
        closureReturnTypeHints = { enable = "always" },
        lifetimeElisionHints = { enable = "always", useParameterNames = true },
        parameterHints = { enable = true },
        reborrowHints = { enable = "always" },
        typeHints = { enable = true },
      },
      diagnostics = {
        enable = true,
      },
    },
  },
}
