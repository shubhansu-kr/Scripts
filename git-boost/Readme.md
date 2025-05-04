# git-boost

`git-boost` is a Zsh utility to:

- Bootstrap a new GitHub repo with standard files
- Link and sync local repos to GitHub
- Standardize all or specific local repos with a README, LICENSE, and CONTRIBUTING.md

## 📦 Installation

```bash
make install
```

Or run `install.sh` manually.

## 🧠 Usage

### Interactive

```bash
git-boost
```

Choose actions with arrow keys via `gum`.

### CLI

```bash
git-boost --init <github-url>

git-boost --link <dir> <github-url>

git-boost --standardize <base-dir>

git-boost man

## 🛠 Dependencies
- [gum](https://github.com/charmbracelet/gum)

## 🙋 Author
[shubhansu-kr](https://github.com/shubhansu-kr)

## 📄 License
MIT
