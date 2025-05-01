# [Chezmoi](https://www.chezmoi.io/user-guide/)


## [Chezmoi Scripts](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)

Chezmoi script file prefixes:

- **run_:** Executed every time you run chezmoi apply.
- **run_onchange_:** Executed if content has changed since last execution
- **run_once_:** Executed once for each unique version of the content. If the script is a template, the content is hashed after template execution. chezmoi tracks the content's SHA256 hash and stores it in a database. If the content has been run before (even under a different filename), the script will not run again unless the content itself changes.
- **before_ and after_:** Scripts are normally run while chezmoi updates your dotfiles. For example, run_b.sh will be run after updating a.txt and before updating c.txt. To run scripts before or after the updates, use the before_ or after_ attributes, respectively, e.g., run_once_before_install-password-manager.sh.