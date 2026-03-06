return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "oxfmt", "prettier", stop_after_first = true },
      typescript = { "oxfmt", "prettier", stop_after_first = true },
    },
  },
}
