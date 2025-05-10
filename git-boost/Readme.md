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

```
                                      ┌─────────────────────┐
                                      │ Start the script    │
                                      └─────────┬───────────┘
                                                │
                     ┌──────────────────────────┼────────────────────────────┐
                     ▼                          ▼                            ▼
           ┌────────────────┐        ┌────────────────────┐         ┌────────────────────┐
           │ --init         │        │ --link              │         │ --standardize       │
           │ github_repo_url│        │ local_dir url       │         │ all dirs in current  │
           └──────┬─────────┘        └────────────┬────────┘         └────────────┬────────┘
                  │                              │                                │
      ┌───────────▼──────────┐        ┌──────────▼────────────┐        ┌──────────▼────────────┐
      │ git clone <url>      │        │ cd into <local_dir>   │        │ For each dir in pwd   │
      │ cd into repo         │        │ git init (if needed)  │        └──────────┬────────────┘
      └──────────┬───────────┘        │ git remote add origin │                   │
                 │                    └──────────┬────────────┘                   ▼
     ┌───────────▼────────────┐                 Add Standard Files:       ┌──────────────────────┐
     │ Add Standard Files     │             ┌────────────────────────┐    │ Check for remote     │
     └──────────┬─────────────┘             │ README, LICENSE, CONTRIB│    │ git remote get-url   │
                ▼                           └────────────────────────┘    └──────────┬───────────┘
       ┌────────────────────┐                      │ Commit                     ┌────▼─────┐
       │ git add .          │                      ▼                            │ if remote│
       │ git commit -m ...  │            ┌─────────────────────────┐            └────┬─────┘
       │ git push -u origin │            │ git add + commit + push │                 ▼
       └────────────────────┘            └─────────────────────────┘            git push changes
```