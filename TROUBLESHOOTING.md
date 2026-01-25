## Troubleshooting

### Configuration doesn't work after restart

1. Delete **ALL** files (including hidden files) in your Emacs directory
2. Try the installation process again
3. If problems persist, file a bug report with:
   - Your Emacs version (`M-x emacs-version`)
   - Your operating system
   - Exact error messages

### My formatting looks weird!

Emacs code formatting is notoriously bad, there even is a [whole
section](https://docs.kernel.org/process/coding-style.html#you-ve-made-a-mess-of-it)
of the Linux Kernel Coding Style about that. The three main culprits for bad
formatting I know of are:
- **c-default-style**
- **c-offsets-alist**
- **eglot-ignored-server-capabilities**

**c-default-style** is the first one to look at. By default, Medicated Emacs'
uses K&R for `c-mode`. Browse the styles using the `customize` menu, and if you
can't find one you like, choose the `user` style and make your own!

**c-offsets-alist** gives you fine-grained control over the indentation of your
C/C++ code, but it can be overriden by Eglot. If you find that your preferred
indentation style gets occasionally shuffled when you press Enter or Tab, the
culprit is likely **eglot-ignored-server-capabilities**. Go to this variable
using the `customize` menu and make sure `documentOnTypeFormattingProvider` is
checked, then save using <kbd>C-x</kbd> <kbd>C-s</kbd>. Voilà!

### Eglot (LSP) errors

Eglot is enabled by default in all programming modes. This is the most common
source of errors because:

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

**Possible solutions:**

1. Install the appropriate LSP server for your language
2. Remove `eglot-ensure` from `prog-mode-hook` in `custom-set-variables` and add Eglot only to specific language modes:
   ```elisp
   (add-hook 'rust-mode-hook #'eglot-ensure)
   ```
3. Disable Eglot entirely and use Emacs with another LSP or without any

#### Java formatting

Eglot expects JDTLS as the language server. JDTLS looks for an Eclipse
formatting file, but it can have a hard time locating it.

To fix this, create a `.dir-locals.el` file at the root of your Java project and
include the following:

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

Be sure to replace "Default.xml" and "Default" with the right format config file
name and profile (found in XML file).

#### Other Elgot configs

This is an amazing blog post explaining how to configure Eglot:
https://joaotavora.github.io/eglot/#Customizing-Eglot
