local jdtls = require "jdtls"
local home = os.getenv "HOME"

local java_path = "/usr/lib/jvm/java-21-openjdk/bin/java"
local jdtls_path = "/usr/share/java/jdtls"
local java_debug_jar = home
  .. "/.local/share/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.53.1.jar"
local lombok_jar = home .. "/.local/share/lombok/lombok.jar"
local workspace_dir = home .. "/.local/share/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

local config = {
  cmd = {
    java_path,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Dfile.encoding=UTF-8",
    "-XX:+UseParallelGC",
    "-XX:GCTimeRatio=4",
    "-XX:AdaptiveSizePolicyWeight=90",
    "-javaagent:" .. lombok_jar,
    "-jar",
    jdtls_path .. "/plugins/org.eclipse.equinox.launcher_1.6.1000.v20250131-0606.jar",
    "-configuration",
    home .. "/.config/jdtls/config_linux",
    "-data",
    workspace_dir,
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
  },
  filetypes = { "java" },
  root_dir = vim.fs.dirname(vim.fs.find({ "pom.xml", "build.gradle", ".git" }, { upward = true })[1])
    or vim.fn.getcwd(),
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
    },
  },
  init_options = {
    bundles = { java_debug_jar },
  },
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>h", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set(
      "n",
      "<leader>lf",
      "<cmd>lua vim.diagnostic.open_float { border = 'rounded' }<CR>",
      { desc = "Floating diagnostic" }
    )
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>ra", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

    jdtls.setup_dap { hotcodereplace = "hotswap" }
    require("jdtls.dap").setup_dap_main_class_configs()

    local dap = require "dap"
    vim.keymap.set("n", "<leader>dc", function()
      print("Configurações DAP para Java: " .. vim.inspect(dap.configurations.java))
    end, { buffer = bufnr, desc = "Listar configurações DAP para Java" })
  end,
}

jdtls.start_or_attach(config)
