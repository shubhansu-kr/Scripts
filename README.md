# Handy Scripts Collection

Welcome to my personal toolbox — a curated collection of scripts I use to automate and simplify everyday tasks on my machine. Each script lives in its own directory with all the essentials to install, understand, and use it seamlessly.

---

## Repository Structure

Each script is organized into its own folder with the following structure:

```yaml
scripts/
├── script-name/
│ ├── script.sh # The main executable script
│ ├── install.sh # Easy installer for the script
│ ├── Makefile # Optional: standard build/install commands
│ ├── README.md # Script-specific documentation
│ └── templates/ # (If needed) supporting files or configs
```

---

## Getting Started

You can navigate into any script folder and either run the `install.sh` or use the provided `Makefile` to set it up.

### Installation (general)

```bash
cd scripts/script-name
./install.sh
# or
make install
```

Each script folder includes a README.md with usage instructions and any dependencies.

## What's Inside?

Scripts range from Git automation to system tweaks. Some examples include:

- `git-boost/` – Initialize and standardize GitHub repos faster

- `zsh-setup/` – Set up a custom Zsh shell with aliases, themes, etc.

- `cleanup-tool/` – Remove temporary files, cache, logs, and more

- `screenshot-sorter/` – Organize screenshots into folders by date

(Actual script names and descriptions may vary. Explore each folder to learn more.)

## Development & Contribution

This repo is meant for personal use, but feel free to fork it, tweak it, or use it as a template for your own scripting needs.

If you'd like to suggest improvements or ideas, PRs are welcome!

## License

This repository is licensed under the MIT License.
