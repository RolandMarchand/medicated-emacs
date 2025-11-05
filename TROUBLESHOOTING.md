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

#### Java formatting

Eglot expects JDTLS as the language server. JDTLS looks for an Eclipse formatting file, but it can have a hard time locating it.

To fix this, create a `.dir-locals.el` file at the root of your Java project and include the following:

```elisp
((java-mode
  . ((eglot-workspace-configuration
      . (lambda (server)
	  `(:java
	   (:format
            (:enabled t
		      :settings
		      (:url ,(concat "file://" (expand-file-name "Default.xml"))
			    :profile "Default")))))))))
```

Be sure to replace "Default.xml" and "Default" with the right format config file name and profile (found in XML file).

#### Other Elgot configs

This is an amazing blog post explaining how to configure Eglot: https://joaotavora.github.io/eglot/#Customizing-Eglot
