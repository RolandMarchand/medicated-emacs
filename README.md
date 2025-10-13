# Medicated Emacs

<p align="center">
  <img src="medicated-emacs.png" alt="Medicated Emacs Logo">
</p>

A minimal, modern Emacs configuration that just works.

## Philosophy

Medicated Emacs enhances Emacs without hiding it. Everything uses standard Emacs patterns and conventions. No frameworks, wrappers, or special systems to learn. If you know how to customize vanilla Emacs, you know how to customize this config.

**What you get:**
- Modern completion (Vertico + Orderless + Marginalia)
- LSP support via Eglot (built-in)
- Git integration (Magit + diff-hl)
- Quality-of-life improvements (better defaults, recent files, etc.)
- Common language modes pre-installed

**What you don't get:**
- Custom keybinding schemes
- Framework abstractions
- Configuration complexity
- Non-standard Emacs patterns

## Requirements

- Emacs 29.0 or later
- Internet connection (for first-time package installation)
- LSP servers (optional, but required for language-specific features)

## Installation

### 1. Prepare your environment

Ensure you have an empty Emacs configuration directory, or none at all. Your Emacs config directory is typically one of:
- `~/.emacs.d/`
- `~/.config/emacs/`

If these exist and contain files, **back them up and delete them**, or Emacs may load conflicting configurations.

### 2. Download the configuration

Place `medicated.el` as `init.el` in one of these locations:
- `~/.emacs.d/init.el` (traditional location, always checked first)
- `~/.config/emacs/init.el` (XDG-compliant location)

**Note:** Emacs prefers `~/.emacs.d/` if it exists. To use the XDG location, ensure `~/.emacs.d/` does not exist.

### 3. First launch

Launch Emacs. On first run:
1. All packages will be automatically downloaded and installed
2. A message will appear: *"First-time setup complete. Please restart Emacs."*
3. Emacs will automatically close after 10 seconds

### 4. Restart and use

Restart Emacs. Your configuration is now ready to use.

## Troubleshooting

### Configuration doesn't work after restart

1. Delete **ALL** files (including hidden files) in your Emacs directory
2. Try the installation process again
3. If problems persist, file a bug report with:
   - Your Emacs version (`M-x emacs-version`)
   - Your operating system
   - Exact error messages

### Eglot (LSP) errors

Eglot is enabled by default in all programming modes. This is the most common source of errors because:

- Eglot expects LSP servers to be already installed on your system
- If a language server is missing, you could see error messages
- Different languages need different LSP servers:
  - **C/C++:** clangd
  - **Rust:** rust-analyzer
  - **Python:** pyright or pylsp
  - **Go:** gopls
  - **JavaScript/TypeScript:** typescript-language-server
  - **Lua:** lua-language-server
  - etc.

**Solutions:**

1. Install the appropriate LSP server for your language
2. Remove `eglot-ensure` from `prog-mode-hook` in `custom-set-variables`
3. Add Eglot only to specific language modes:
   ```elisp
   (add-hook 'rust-mode-hook #'eglot-ensure)
   ```
4. Disable Eglot entirely and use Emacs without LSP

## Learning Emacs

If you're new to Emacs, start with the built-in tutorial:

```
M-x help-with-tutorial RET
```

(That's: `Alt+x`, type "help-with-tutorial", press Enter)

Learn Emacs as you would with vanilla Emacs. This config doesn't change fundamental concepts. Standard Emacs documentation and resources apply directly.

## Customization

Don't like something? Change it as you would in vanilla Emacs:

- **Theme:** `M-x customize-themes` or edit `custom-enabled-themes`
- **Font:** `M-x customize-face default` or set in `default-frame-alist`
- **Keybindings:** Use `global-set-key` or `local-set-key`
- **Any setting:** `M-x customize-variable` or edit `custom-set-variables`

This config does nothing special, it's just Emacs with better defaults.

## What's Included

### 16 Third-Party Packages

- **csv-mode:** CSV file editing
- **diff-hl:** Git diff indicators in the fringe
- **doom-modeline:** Modern mode-line
- **doom-themes:** Collection of themes (Gruvbox used by default)
- **go-mode:** Go language support
- **helpful:** Better help buffers
- **lua-mode:** Lua language support
- **magit:** Git interface
- **marginalia:** Completion annotations
- **markdown-mode:** Markdown editing
- **orderless:** Fuzzy completion matching
- **rainbow-delimiters:** Colored parentheses by depth
- **rust-mode:** Rust language support
- **typescript-mode:** TypeScript language support
- **vertico:** Vertical completion UI
- **yaml-mode:** YAML file editing

### Built-in Enhancements

- Recent files tracking (`recentf-mode`)
- Cursor position memory (`save-place-mode`)
- Command history persistence (`savehist-mode`)
- Window configuration undo (`winner-mode`)
- Keybinding hints (`which-key-mode`)
- Visual line numbers (`display-line-numbers`)
- Better scrolling behavior
- Backup files in `~/.emacs.d/backups/`
- Auto-save files in `~/.emacs.d/auto-saves/`

## Expected Behavior

All behavior (both functional and errors) from this config represents the normal Emacs experience, or bugs in the included third-party packages. When troubleshooting issues, standard Emacs debugging approaches apply. There's no special configuration layer to navigate.

## License

This library is licensed under the [0BSD](https://opensource.org/license/0bsd) license.
