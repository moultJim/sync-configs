# Push local changes to remote GitHub - std 3-step: stage, commit, push 
git add .
git commit -m "commit message"
git push origin main

# First-Time Setup (Brand New Repository)
git init -b main
git add .
git commit -m "Initial commit"
git remote add origin [https://github.com ?]
git push -u origin main

# Repair bad setup -- partial URLs, attempted link to https
git remote remove origin 2>/dev/null

# First-time linking second device to existing repo
git remote add origin git@github.com:moultJim/nvim-jm.git
git remote -v

# Relevant tips 
On git remote, expect git address (e.g. git@github.com:moultJim/nvim-jm.git)
  for both fetch and push.
On git push -u origin main
  -u (or --set-upstream) flag only required first time you push.

# Clone an existing github repo 
git clone git@github.com:moultJim/sync-configs.git  [optional dest ~/dotfiles]

# Clean-up/remove items should be in .gitignore (from repo dir)
git rm -r --cached systemd/.config/systemd/user/timers.target.wants/
  Then add it to your .gitignore:

# Ignore systemd activation state folders
*.target.wants/
*.wants/

# Switch remote URL from HTTPS to SSH directly (if cloned https in error)
git remote set-url origin git@github.com:moultJim/sync-configs.git
General Rule for GitHub Cloning: click green Code button, choose SSH tab.

# Setting up SSH key
1. Check for existing valid keys: ls -al ~/.ssh
  Look for pair of files matching id_ed25519 (private) and id_ed25519.pub (public).
  or id_rsa and id_rsa.pub.
2. Generate new key if needed: ssh-keygen -t ed25519 -C "your_github_email@example.com"
  Enter to accept default save path. Passphrase or empty.
3. Register it locally with SSH Agent (ensures auto-handoff for Git commands) 
  Start agent in background: eval "$(ssh-agent -s)"
  Link private key to agent: ssh-add ~/.ssh/id_ed25519
4. Add public key to GitHub
  Print public key to terminal: cat ~/.ssh/id_ed25519.pub
  Copy entire output block (starts with ssh-ed25519 and ends with email address).
  Paste to SSH key on GitHub in your browser.
5. Test connection: ssh -T git@github.com

# Reload systemd after underlying source layout shifted.
  Scan new symlink locations and configuration states: systemctl --user daemon-reload
  Restart specific timer/service: systemctl --user restart your-timer-name.timer

# Strategic tips for .gitignore to keep your shared repository lightweight:
  Only track custom configuration files (e.g., .zshrc, config.lua, init.vim).
  Never track plugins, extensions, caches, or state directories. 

# Zsh dynamic files and plugin states (for .gitignore)
  .zcompdump*
  .zsh_history
  .zsh-update
  plugins/
  cache/

# General Application Caches & Logs (for .gitignore)
  *.log
  .cache/

# Github instruct on creating new repo
echo "# nvim-ba" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/moultJim/nvim-ba.git
git push -u origin main

# Github instruct on pushing an existing repo
git remote add origin https://github.com/moultJim/nvim-ba.git
git branch -M main
git push -u origin main

