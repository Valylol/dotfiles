-- ~/.config/nvim/init.lua
-- Simple but solid Neovim config

-- Suppress lspconfig deprecation warnings
vim.deprecate = function() end

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
vim.opt.number = true           -- Line numbers
vim.opt.relativenumber = true   -- Relative line numbers
vim.opt.mouse = "a"             -- Enable mouse
vim.opt.ignorecase = true       -- Ignore case in search
vim.opt.smartcase = true        -- Unless uppercase is used
vim.opt.hlsearch = false        -- Don't highlight searches
vim.opt.wrap = false            -- Don't wrap lines
vim.opt.breakindent = true      -- Indent wrapped lines
vim.opt.tabstop = 4             -- Tab width
vim.opt.shiftwidth = 4          -- Indent width
vim.opt.expandtab = true        -- Spaces instead of tabs
vim.opt.termguicolors = true    -- True color support
vim.opt.signcolumn = "yes"      -- Always show sign column
vim.opt.updatetime = 250        -- Faster completion
vim.opt.timeoutlen = 300        -- Faster key sequence completion
vim.opt.scrolloff = 8           -- Keep 8 lines visible when scrolling
vim.opt.cursorline = true       -- Highlight current line

-- Better swap/backup file handling
vim.opt.swapfile = false        -- No swap files (auto-save handles it)
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true         -- Persistent undo
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo//"    -- Undo directory

-- Create undo directory if it doesn't exist
vim.fn.mkdir(vim.fn.stdpath("data") .. "/undo", "p")

-- Install lazy.nvim (plugin manager) if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    end
    vim.opt.rtp:prepend(lazypath)

    -- Plugin setup
    require("lazy").setup({
        -- Dashboard with recent files
        {
            "nvimdev/dashboard-nvim",
            event = "VimEnter",
            config = function()
            require("dashboard").setup({
                theme = "doom",
                config = {
                    header = {
                        "",
                        "██╗     ██╗   ██╗██╗   ██╗██╗   ██╗ █████╗ ██╗     ",
                        "██║     ██║   ██║██║   ██║██║   ██║██╔══██╗██║     ",
                        "██║     ██║   ██║██║   ██║██║   ██║███████║██║     ",
                        "██║     ██║   ██║╚██╗ ██╔╝╚██╗ ██╔╝██╔══██║██║     ",
                        "███████╗╚██████╔╝ ╚████╔╝  ╚████╔╝ ██║  ██║███████╗",
                        "╚══════╝ ╚═════╝   ╚═══╝    ╚═══╝  ╚═╝  ╚═╝╚══════╝",
                        "",
                    },
                    center = {
                        {
                            icon = "  ",
                            desc = "Recent files                            ",
                            action = "Telescope oldfiles",
                            key = "r",
                        },
                        {
                            icon = "  ",
                            desc = "Find file                               ",
                            action = "Telescope find_files",
                            key = "f",
                        },
                        {
                            icon = "  ",
                            desc = "New file                                ",
                            action = "enew",
                            key = "n",
                        },
                        {
                            icon = "  ",
                            desc = "Quit                                    ",
                            action = "quit",
                            key = "q",
                        },
                    },
                    footer = {
                        "",
                        "━━━━━━━━━━━━━━━━━━━━━ Keybinds ━━━━━━━━━━━━━━━━━━━━━",
                        "",
                        "  Files:  SPC+e (tree)  SPC+ff (find)  SPC+fr (recent)",
                                       "  Edit:   Ctrl+s (save)  Ctrl+z (undo)  SPC+u (undo tree)",
                                       "  LSP:    gd (definition)  K (docs)  SPC+rn (rename)",
                                       "  Navigate:  Shift+h/l (buffers)  Ctrl+hjkl (windows)",
                                       "  Surround:  ysiw\" (wrap word)  cs\"' (change quotes)",
                                       "",
                    },
                },
            })
            end,
            dependencies = { "nvim-tree/nvim-web-devicons" },
        },

        -- Color scheme (uses your wallust colors)
    {
        "AlphaTechnolog/pywal.nvim",
        lazy = false,
        priority = 1000,
        config = function()
        vim.cmd([[colorscheme pywal]])
        end,
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
        require("nvim-tree").setup({
            view = {
                width = 30,
                adaptive_size = true,  -- Auto-adapt to content
            },
            filters = { dotfiles = false },
            renderer = {
                group_empty = true,
            },
        })
        end,
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
        require("telescope").setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                    },
                },
                file_ignore_patterns = { "node_modules", ".git/" },
                hidden = true,  -- Show hidden files
            },
            pickers = {
                find_files = {
                    hidden = true,  -- Show hidden files in file picker
                    find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
                },
            },
        })
        end,
    },

    -- Treesitter for better syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "vim", "bash", "python", "javascript", "typescript", "rust", "c" },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
        end,
    },

    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim",
        },
        config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls" },  -- Only install lua_ls automatically
            automatic_installation = false,    -- Don't auto-install others
        })

        -- Show progress notifications
        require("fidget").setup()

        -- LSP keybinds
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event)
            local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
            end

            map("gd", vim.lsp.buf.definition, "Go to definition")
            map("gr", vim.lsp.buf.references, "Go to references")
            map("K", vim.lsp.buf.hover, "Hover documentation")
            map("<leader>rn", vim.lsp.buf.rename, "Rename")
            map("<leader>ca", vim.lsp.buf.code_action, "Code action")
            end,
        })

        -- Setup language servers (suppress deprecation warning)
    local servers = { "lua_ls", "bashls", "pyright" }
    for _, server in ipairs(servers) do
        local ok, lspconfig = pcall(require, "lspconfig")
        if ok and lspconfig[server] then
            lspconfig[server].setup({})
            end
            end
            end,
    },

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            snippet = {
                expand = function(args)
                luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                                                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                                                ["<Tab>"] = cmp.mapping(function(fallback)
                                                if cmp.visible() then
                                                    cmp.select_next_item()
                                                    else
                                                        fallback()
                                                        end
                                                        end, { "i", "s" }),
                                                        ["<S-Tab>"] = cmp.mapping(function(fallback)
                                                        if cmp.visible() then
                                                            cmp.select_prev_item()
                                                            else
                                                                fallback()
                                                                end
                                                                end, { "i", "s" }),
            }),
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
            },
        })
        end,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
        require("lualine").setup({
            options = { theme = "auto" },
        })
        end,
    },

    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    -- Comment plugin
    {
        "numToStr/Comment.nvim",
        config = true,
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        config = true,
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
        require("ibl").setup({
            indent = {
                char = "▏",
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = false,
                highlight = { "Function", "Label" },
            },
            exclude = {
                filetypes = { "dashboard", "help", "terminal", "lazy" },
            },
        })
        end,
    },

    -- Better search
    {
        "kevinhwang91/nvim-hlslens",
        config = function()
        require("hlslens").setup()
        vim.keymap.set("n", "n", "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>")
        vim.keymap.set("n", "N", "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>")
        end,
    },

    -- Surround text with quotes/brackets
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = true,
    },

    -- Todo comments highlighting
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
    },

    -- Undo tree
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle undo tree" },
        },
    },

    -- Auto-save
    {
        "pocco81/auto-save.nvim",
        config = function()
        require("auto-save").setup({
            enabled = true,
            trigger_events = { "InsertLeave", "TextChanged" },
            write_all_buffers = false,
            debounce_delay = 135,
        })
        end,
    },

    -- Better buffer tabs
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers",
                numbers = "none",
                diagnostics = "nvim_lsp",
                separator_style = "slant",
                show_buffer_close_icons = false,
                show_close_icon = false,
            },
        })
        end,
    },

    -- Which-key for keybind hints
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
        local wk = require("which-key")
        wk.setup({
            preset = "modern",
        })

        -- Register keybind descriptions
        wk.add({
            { "<leader>f", group = "Find" },
            { "<leader>ff", desc = "Find files" },
            { "<leader>fg", desc = "Live grep" },
            { "<leader>fb", desc = "Find buffers" },
            { "<leader>fr", desc = "Recent files" },
            { "<leader>e", desc = "Toggle file tree" },
            { "<leader>w", desc = "Save" },
            { "<leader>q", desc = "Quit" },
            { "<leader>x", desc = "Close buffer" },
            { "<leader>r", group = "LSP" },
            { "<leader>rn", desc = "Rename" },
            { "<leader>ca", desc = "Code action" },
            { "<leader>u", desc = "Toggle undo tree" },
            { "gcc", desc = "Comment line" },
            { "gc", desc = "Comment", mode = "v" },
            { "gd", desc = "Go to definition" },
            { "gr", desc = "Go to references" },
            { "K", desc = "Show docs" },
            { "<S-h>", desc = "Previous buffer" },
            { "<S-l>", desc = "Next buffer" },
            { "<C-h>", desc = "Move left window" },
            { "<C-j>", desc = "Move down window" },
            { "<C-k>", desc = "Move up window" },
            { "<C-l>", desc = "Move right window" },
            { "<C-s>", desc = "Save" },
            { "<C-a>", desc = "Select all" },
            { "<C-z>", desc = "Undo" },
            { "<C-y>", desc = "Redo" },
        })
        end,
    },
    })

    -- Keybinds
    local keymap = vim.keymap.set

    -- Better navigation
    keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
    keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
    keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
    keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

    -- File explorer
    keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

    -- Telescope
    keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
    keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
    keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
    keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })

    -- Buffer navigation
    keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
    keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
    keymap("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })

    -- Better indenting
    keymap("v", "<", "<gv")
    keymap("v", ">", ">gv")

    -- Move lines
    keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
    keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
    keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
    keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

    -- Clear search highlight
    keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlight" })

    -- Familiar editor keybinds
    keymap("i", "<C-BS>", "<C-w>", { desc = "Delete word backwards" })
    keymap("i", "<C-h>", "<C-w>", { desc = "Delete word backwards (alternative)" })
    keymap("n", "<C-a>", "ggVG", { desc = "Select all" })
    keymap("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save in insert mode" })
    keymap("n", "<C-s>", ":w<CR>", { desc = "Save" })
    keymap("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
    keymap("n", "<C-v>", '"+p', { desc = "Paste from clipboard" })
    keymap("i", "<C-v>", '<C-r>+', { desc = "Paste from clipboard in insert" })
    keymap("n", "<C-z>", "u", { desc = "Undo" })
    keymap("i", "<C-z>", "<Esc>ua", { desc = "Undo in insert mode" })
    keymap("n", "<C-y>", "<C-r>", { desc = "Redo" })
    keymap("i", "<C-y>", "<Esc><C-r>a", { desc = "Redo in insert mode" })

    -- Auto-resize splits when window is resized
    vim.api.nvim_create_autocmd("VimResized", {
        callback = function()
        vim.cmd("wincmd =")
        end,
    })

    -- Save and quit
    keymap("n", "<leader>w", ":w<CR>", { desc = "Save" })
    keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })

    -- Comment (gcc to comment line, gc in visual mode)
    -- Handled by Comment.nvim plugin
