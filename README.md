# Dotfiles

Welcome! You've found my personal dotfiles repository. Dotfiles are configuration files in Unix-based systems, shaping the environment to the user's preferences. They control the appearance and functionality of various tools such as Zsh[^1], Vim[^2], Tmux[^3], Git[^4], and more.

Over the years, I've tweaked these files to create an efficient, simple, and pleasurable terminal experience. They're tailored to my workflow but might serve as a starting point for your personal setup.

Don't just copy them, though. The power of dotfiles lies in crafting a system perfect for you. Understand what each line does, experiment, and adapt to your needs.

Thanks for visiting!

## Overview

The repository is organized as follows:

```
. 
├── zsh/
│   └── zshrc.symlink
└── README.md
```

## Setting Up Environment Variables
Some environment variables need to be set for the dotfiles to work as expected. Instead of putting these variables directly in your dotfiles, I recommended storing them in a separate file: `~/.localrc`.

Create this file and add your environment variables in the following format `export VARNAME=value`.

```zsh
export LC_CTYPE=UTF-8
```

The environment variables in `~/.localrc` will be automatically sourced when you open a new terminal session, as specified in the provided `.zshrc`.

## License

These dotfiles are released under the MIT License. 

## Contributing

Feel free to raise an issue or submit a pull request with suggestions or improvements.

[^1]: https://www.zsh.org
[^2]: https://www.vim.org
[^3]: https://github.com/tmux/tmux/wiki
[^4]: https://git-scm.com
