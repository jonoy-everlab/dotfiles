# dotfiles

## Bootstrap

Paste this into any terminal (macOS or Linux):

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/yourusername/dotfiles
```

That's it. The following runs automatically:

1. Installs chezmoi
2. Installs Homebrew
3. Installs all packages via Brewfile
4. Sets fish as default shell
5. Installs mise tools
6. Installs fisher plugins
7. Installs nvim plugins

## After bootstrap

Authenticate services manually (credentials are never tracked):

```sh
gcloud auth login
gh auth login
```

## Updating

On any machine, pull latest and apply:

```sh
chezmoi update
```

## Adding new packages

```sh
# Edit Brewfile
chezmoi edit ~/.config/chezmoi/Brewfile

# Apply
brew bundle install
```

## Adding new dotfiles

```sh
chezmoi add ~/.config/some/file
cd ~/.local/share/chezmoi && git add . && git commit -m "add file" && git push
```
