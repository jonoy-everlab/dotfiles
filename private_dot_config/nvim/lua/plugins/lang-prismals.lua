return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        prismals = {
          -- Configure Prisma LS for .zmodel files
          filetypes = { "prisma", "zmodel" },
        },
      },
    },
  },
}
