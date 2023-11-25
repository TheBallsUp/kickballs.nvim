--- Welcome to kickballs.nvim!
---
--- This is a basic neovim configuration with quality of life defaults that's supposed to act as
--- a starting point for your own personal configuration. You're supposed to fork this repository
--- and make it your own! There are lots of comments included, some nicer default options, commonly
--- agreed on keymaps and some plugins. If you don't like anything in here, feel free to delete it!
--- It's now your config.
---
--- The first time you open neovim after installing this file, your plugin manager will be
--- installed. After it's done it will tell you to run `:BallsInstall` to install your plugins.
--- After your plugins are installed you need to restart neovim for them to load.

--- Options
---
--- If you want to find out more about any of these, simply run `:help '<option>'`.
--- For example, if you don't know what the `autoindent` option does, run `:help 'autoindent'`.

--- Indentation
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.breakindentopt = { shift = 2, list = 2 }
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = vim.o.shiftwidth -- Make sure 'tabstop' and 'shiftwidth' have the same value
vim.opt.wrap = true

--- Command completion
vim.opt.wildoptions = { "fuzzy", "pum" }
vim.opt.path = { ".", "**" }

--- UI

--- 'colorcolumn' is a visual guide that shows you how long your lines are.
--- If 'textwidth' is not already set, we default to a value of 101.
--- Otherwise we take the current 'textwidth' value + 1 so you can type until the colorcolumn but
--- without crossing it.
---
--- This is just visual and is supposed to help you; it does not have any effect on formatting!
if vim.o.textwidth == 0 then
  vim.opt.colorcolumn = "101"
else
  vim.opt.colorcolumn = tostring(vim.o.textwidth + 1)
end

vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true

--- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true

--- Undo history
vim.opt.undodir = vim.fs.joinpath(vim.fn.stdpath("state") --[[@as string]], "undodir")
vim.opt.undofile = true

--- Diagnotics
vim.diagnostic.config({
  underline = false,
  severity_sort = true,
})

--- Keymaps

--- This is your leader key.
---
--- It will be used for most of your custom keymaps to ensure they don't conflict with anything
--- that's builtin. It is set to the space key here, but feel free to change it! Many people like
--- the `,` key as well.
---
--- See `:help mapleader` for more information.
vim.g.mapleader = " "

--- Wrapper function for custom keymaps.
---
--- See `:help vim.keymap.set()` for more information.
local map = function(modes, keys, action, desc, opts)
  local default_opts = { silent = true, desc = desc }

  opts = vim.F.if_nil(opts, {})
  opts = vim.tbl_extend("force", default_opts, opts)

  vim.keymap.set(modes, keys, action, opts)
end

--- Usually you don't want to yank single characters.
--- For the rare situations where you do need to, you can `vd`.
map("n", "x", "\"_x", "Deletes a single character without yanking it.")

--- Move up/down while respecting soft line wraps.
map("n", "j", "v:count == 0 ? 'gj' : 'j'", "`j` but it respects soft line wraps.", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", "`k` but it respects soft line wraps.", { expr = true })

--- Yanking and pasting using the system clipboard.
---
--- If you're using WSL make sure your Windows clipboard is actually accessible from within WSL.
--- See `:help clipboard-wsl` for more information.
---
--- If you're on Linux make sure to install either `xclip` or `wl-clipboard` (depending on whether
--- you use X11 or Wayland).

map({ "n", "v" }, "<Leader>y", "\"+y", "Yanks to the system clipboard.")
map({ "n", "v" }, "<Leader>p", "\"+p", "Pastes from the system clipboard.")
map({ "n", "v" }, "<Leader>P", "\"+P", "Pastes from the system clipboard without yanking the deleted text.")

--- Stay in visual mode when indenting / dedenting text
map("x", ">", ">gv", "Indents text in visual mode without losing visual selection.")
map("x", "<", "<gv", "Dedents text in visual mode without losing visual selection.")

--- Move lines around
map("n", "<A-j>", ":m .+1<CR>==", "Moves the current line down by 1.")
map("n", "<A-k>", ":m .-2<CR>==", "Moves the current line up by 1.")
map("x", "<A-j>", ":m '>+1<CR>=gv", "Moves the current line down by 1.")
map("x", "<A-k>", ":m '<-2<CR>=gv", "Moves the current line up by 1.")

--- Navigate various lists
map("n", "[q", ":cprev<CR>", "Jumps to the previous entry in the quickfix list.")
map("n", "]q", ":cnext<CR>", "Jumps to the next entry in the quickfix list.")
map("n", "[Q", ":cfirst<CR>", "Jumps to the first entry in the quickfix list.")
map("n", "]Q", ":clast<CR>", "Jumps to the last entry in the quickfix list.")

map("n", "[b", ":bprev<CR>", "Jumps to the previous buffer.")
map("n", "]b", ":bnext<CR>", "Jumps to the next buffer.")

map("n", "[d", vim.diagnostic.goto_prev, "Jumps back one diagnostic message.")
map("n", "]d", vim.diagnostic.goto_next, "Jumps forward one diagnostic message.")
map("n", "gl", vim.diagnostic.open_float, "Opens a floating window with diagnostics from the current line.")

--- Navigate between windows
map({ "n", "v" }, "<C-h>", "<cmd>wincmd h<CR>", "Moves 1 window left.")
map({ "n", "v" }, "<C-j>", "<cmd>wincmd j<CR>", "Moves 1 window down.")
map({ "n", "v" }, "<C-k>", "<cmd>wincmd k<CR>", "Moves 1 window up.")
map({ "n", "v" }, "<C-l>", "<cmd>wincmd l<CR>", "Moves 1 window right.")

--- Better defaults for terminal mode
map("t", "<C-]>", "<C-\\><C-n>", "Goes from terminal mode to normal mode.")
map("t", "<S-Space>", "<Space>")
map("t", "<C-Space>", "<Space>")
map("t", "<S-BS>", "<BS>")
map("t", "<C-BS>", "<C-w>")
map("t", "<C-CR>", "<CR>")

--- Save and execute the current config file.
---
--- You can use this to reload your config while you're editing it without having to restart nvim.
map("n", "<Leader>x", function()
  if vim.o.filetype == "vim" or vim.o.filetype == "lua" then
    vim.cmd("write | source %")
  end
end, "Saves and re-executes the current vim / lua file.")

--- Plugin manager

--- This makes sure balls.nvim (your plugin manager) is installed.
---
--- See `:help balls`.
local config_path = vim.fn.stdpath("config") --[[@as string]]
local balls_path = vim.fs.joinpath(config_path, "pack", "balls", "start", "balls.nvim")

--- This is currently an incorrect warning and will hopefully go away when 0.10 releases.
--- @diagnostic disable-next-line
if vim.uv.fs_stat(balls_path) == nil then
  local command = {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/TheBallsUp/balls.nvim",
    balls_path,
  }

  local result = vim.system(command):wait()

  if result.code ~= 0 then
    error("Failed to install balls.nvim: " .. result.stderr)
  end

  vim.notify("Installed balls.nvim! Run `:BallsInstall` to install your plugins.")
  vim.cmd.packloadall()
  vim.cmd.helptags(vim.fs.joinpath(balls_path, "doc"))
end

local balls_installed, Balls = pcall(require, "balls")

if not balls_installed then
  vim.notify("balls.nvim not found. Plugins are disabled!", vim.log.levels.WARN)
  return
end

--- Colorscheme

Balls:register("https://github.com/catppuccin/nvim", {
  name = "catppuccin",
})

local catppuccin_installed, catppuccin = pcall(require, "catppuccin")

if catppuccin_installed then
  -- See `:help catppuccin-configuration` if you want to do any more configuration.
  catppuccin.setup({
    flavour = "mocha",
  })

  -- neovim also comes with a bunch of builtin colorschemes. Run `:colorscheme ` and hit tab!
  -- Most of them are pretty hideous but `habamax` and `quiet` are pretty good.
  --
  -- Catppuccin is better though :)
  vim.cmd.colorscheme("catppuccin")
end

--- Treesitter
---
--- Treesitter is responsible for better syntax highlighting, indentation, folding, and more!
--- The way it is setup it will install any missing parsers for the current file automatically.
--- If you want to explicitly install a parser run `:TSInstall <language>` or put it in the
--- `ensure_installed` table below.
---
--- Treesitter requires a C compiler to compile the parsers. If you're on Windows you might not have
--- a C compiler installed, or the one you have doesn't work very well with treesitter. From
--- experience zig has proven to be the most reliable on Windows, so if you have issues with
--- treesitter I recommend you install zig:
---
---   <https://ziglang.org/download/>
---
--- And read this section of the nvim-treesitter docs:
---
---   <https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support#which-c-compiler-will-be-used>
---
--- And tell treesitter to use zig for compiling parsers:
---
---   require("nvim-treesitter.install").compilers = { "zig" }
---
--- To make sure everything goes smoothly I also recommend deleting old failed parsers before trying
--- to recompile them with zig. To do that, simply delete the following directory starting at the
--- root of your nvim config: `pack/balls/start/nvim-treesitter/parser`
---
--- Then try to compile the parsers again.

Balls:register("https://github.com/nvim-treesitter/nvim-treesitter")

local treesitter_installed, treesitter = pcall(require, "nvim-treesitter.configs")

if treesitter_installed then
  -- Uncomment this line if you want to use zig for compiling parsers:
  -- require("nvim-treesitter.install").compilers = { "zig" }

  -- See `:help nvim-treesitter-quickstart` for more information.
  treesitter.setup({
    -- You can list parser you definitely want installed here.
    -- You can add whatever languages you regularly work with here. For a full list of supported
    -- languages refer to this:
    --
    --   <https://github.com/nvim-treesitter/nvim-treesitter/#supported-languages>
    ensure_installed = {
      -- These are highly recommended because they're used in various `:help` documents.
      "vim", "vimdoc", "lua", "query", "markdown", "bash", "python",

      -- These are just some example languages :)
      "rust", "javascript", "typescript",
    },

    auto_install = true,

    highlight = {
      enable = true,
    },

    indent = {
      enable = true,
    },
  })
end

--- File explorer
---
--- The default file explorer that ships with vim and neovim is decent, but oil is just simply
--- better.
---
--- It lets you edit the filesystem like a buffer, which means you can use your familiar vim motions
--- and do bulk operations really efficiently. It's really intuitive.

Balls:register("https://github.com/stevearc/oil.nvim")

local oil_installed, oil = pcall(require, "oil")

if oil_installed then
  -- See `:help oil-options` if you want to change any defaults.
  oil.setup()

  map("n", "<Leader>e", oil.open, "Opens Oil.")
end

--- Fuzzy Finder
---
--- Telescope can fuzzy find a lot of things. Type `:Telescope ` and hit tab to get an idea of how
--- many things!
---
--- I have set a few keymaps below for the pickers you'll use most commonly. They follow mneumonics,
--- so feel free to change them to keymaps that feel more intuitive to you.

Balls:register("https://github.com/nvim-lua/plenary.nvim")
Balls:register("https://github.com/nvim-telescope/telescope.nvim")

local plenary_installed = pcall(require, "plenary")
local telescope_installed, telescope = pcall(require, "telescope")

if plenary_installed and telescope_installed then
  -- See `:help telescope.nvim` if you want to change any defaults.
  telescope.setup({})

  local pickers = require("telescope.builtin")

  map("n", "<Leader>ff", pickers.find_files, "[F]ind [F]iles")
  map("n", "<Leader>fb", pickers.buffers, "[F]ind [B]uffers")
  map("n", "<Leader>fh", pickers.help_tags, "[F]ind [H]elp")
  map("n", "<Leader>fo", pickers.vim_options, "[F]ind [O]ptions")
  map("n", "<Leader>fk", pickers.keymaps, "[F]ind [K]eymaps")
  map("n", "<Leader>fc", pickers.commands, "[F]ind [C]ommands")
  map("n", "<Leader>fd", pickers.diagnostics, "[F]ind [D]iagnostics")
  map("n", "<Leader>fq", pickers.quickfix, "[F]ind [Q]uickfix")
  map("n", "<Leader>fr", pickers.lsp_references, "[F]ind [R]eferences")
  map("n", "<Leader>fi", pickers.lsp_implementations, "[F]ind [I]mplementations")
  map("n", "<Leader>fs", pickers.lsp_workspace_symbols, "[F]ind [S]ymbols")
end

--- LSP
---
--- LSP is a protocol. neovim implements this protocol. The protocol consists of a client-server
--- relationship, where neovim is the client. If you want to get "language support" for
--- <insert language> you need to find and install the appropriate language server on your system
--- and then configure neovim to use that language server. There are some examples below; just
--- replace the servers you don't need with the ones you need and make sure they're installed on
--- your system and in your $PATH.
---
--- If you are having trouble you can use `:LspInfo` to check which servers are configured and which
--- servers are currently attached to the buffer. If something looks off in there you can use
--- `:LspLog` to check the logs for any warnings or errors.

-- This autocommand will run when any language server attaches to a buffer.
-- It's a good place to put common configuration that you want to apply to all your servers.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("kickballs_lsp_attach", { clear = true }),
  callback = function(event)
    -- Yet another keymap wrapper. This time for creating keymaps that only work in the current
    -- buffer. We don't want to map LSP functionality globally as it could cause errors when you
    -- try to use them without a language server attached.
    local bufmap = function(modes, keys, action, desc)
      vim.keymap.set(modes, keys, action, { buffer = event.buf, desc = desc })
    end

    bufmap("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    bufmap("n", "gD", vim.lsp.buf.type_definition, "[G]oto Type [D]efinition")
    bufmap("n", "gr", vim.lsp.buf.rename, "[R]ename symbol")
    bufmap("n", "gR", vim.lsp.buf.references, "[G]oto [R]eferences")
    bufmap("n", "gi", vim.lsp.buf.implementation, "[G]oto [I]mplementations")
    bufmap("n", "ga", vim.lsp.buf.code_action, "Code [A]ctions")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    assert(client, "LSP client crashed?")

    -- Formatting on save
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = event.buf,
        group = vim.api.nvim_create_augroup("kickballs_format_on_save_b_" .. tostring(event.buf), {
          clear = true,
        }),
        callback = function(ev)
          vim.lsp.buf.format({
            bufnr = ev.buf,
            id = client.id,
          })
        end,
      })
    end
  end,
})

Balls:register("https://github.com/neovim/nvim-lspconfig")

local lspconfig_installed, lspconfig = pcall(require, "lspconfig")

if lspconfig_installed then
  -- These are your LSP servers. They are external programs that you need to install on your system.
  -- You can find a list of supported servers here:
  --
  --   <https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md>
  --
  -- As well as links to documentation.
  local servers = { "rust_analyzer", "tsserver" }
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_installed, cmp = pcall(require, "cmp_nvim_lsp")

  if cmp_installed then
    -- These are special LSP capabilities that allow for auto-imports when using completion.
    capabilities = cmp.default_capabilities(capabilities)
  end

  for _, server in ipairs(servers) do
    -- See `:help vim.lsp.start` for what you can pass to this function.
    -- nvim-lspconfig calls that function internally and has sane defaults for a lot of servers.
    -- Anything you pass into `.setup()` here will override any defaults set by nvim-lspconfig.
    lspconfig[server].setup({ capabilities = capabilities })
  end

  -- lua_ls requires special treatment :)
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,

          -- These are directories you want lua_ls to scan.
          --
          -- You should at least keep `vim.env.VIMRUNTIME` as that will give you hover info,
          -- diagnostics, and completion for `vim.*` items.
          library = {
            -- neovim core
            vim.env.VIMRUNTIME,

            -- balls.nvim
            vim.fs.joinpath(balls_path, "lua"),
            vim.fs.joinpath(balls_path, "plugin"),

            -- your own config
            vim.fs.joinpath(config_path, "lua"),
          },
        },
      },
    },
  })
end

--- Completion
---
--- nvim-cmp is a completion *engine*. This means that it is responsible for wiring different
--- *sources* together so they appear in a nice menu. If you want LSP completion, you need to
--- install the LSP source. If you want custom snippets, you need to install a snippet source, and
--- so on. The nvim-cmp wiki has a list of popular sources that you might want:
---
---   <https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources>
---
--- I have reduced it to the minimum here, with a single source only for LSP.
---
--- If you want custom snippets you also need to install a Snippet engine like LuaSnip as well as an
--- appropriate source:
---
---   <https://github.com/L3MON4D3/LuaSnip>
---   <https://github.com/saadparwaiz1/cmp_luasnip>

Balls:register("https://github.com/hrsh7th/nvim-cmp")
Balls:register("https://github.com/hrsh7th/cmp-nvim-lsp")

local cmp_installed, cmp = pcall(require, "cmp")

if cmp_installed then
  -- See `:help nvim-cmp` for more information.
  cmp.setup({
    -- These are your completion sources.
    -- Whenever you install a new source you need to list it here.
    -- The priority of suggestions depends on the order of the sources in this table.
    sources = {
      { name = "nvim_lsp" },
    },

    -- These are your completion keymaps.
    mapping = {
      -- Confirm a completion
      ["<CR>"] = cmp.mapping.confirm(),

      -- Cancel the completion
      ["<C-e>"] = cmp.mapping.abort(),

      -- Force the completion menu to open
      ["<C-Space>"] = cmp.mapping.complete(),

      -- Select the next item
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end),

      -- Select the previous item
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end),

      -- Jump one snippet position backwards
      ["<C-h>"] = cmp.mapping(function(fallback)
        if vim.snippet.jumpable(-1) then
          vim.snippet.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),

      -- Jump one snippet position forwards
      ["<C-l>"] = cmp.mapping(function(fallback)
        if vim.snippet.jumpable(1) then
          vim.snippet.jump(1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },

    -- Snippet expansion either from your LSP or custom snippets with e.g. LuaSnip
    snippet = {
      expand = function(args)
        vim.snippet.expand(args.body)

        -- If you want to use LuaSnip instead:
        -- luasnip.lsp_expand(args.body)
      end,
    },
  })
end

--- Commenting
---
--- This allows you to comment out entire lines or ranges determined by a motion.
--- The basic keymaps are `gc` and `gcc`.
--- `gc` will take a motion to comment out a specific range according to a motion (e.g. `gcw`).
--- `gcc` will comment out the current line.
--- Both of them are toggles.

Balls:register("https://github.com/numToStr/Comment.nvim")

local comment_installed, comment = pcall(require, "Comment")

if comment_installed then
  -- See `:help comment-nvim` if you want to change any defaults.
  comment.setup()
end

--- Statusline
---
--- This just gives you some nice information at the bottom of the screen :)

Balls:register("https://github.com/nvim-lualine/lualine.nvim")

local lualine_installed, lualine = pcall(require, "lualine")

if lualine_installed then
  -- See `:help lualine` for more information.
  lualine.setup({
    options = {
      theme = "catppuccin",
    },
  })
end
