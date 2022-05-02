# dotfiles
This is a collection of my config files, colloquially known as [dotfiles](https://wiki.archlinux.org/title/Dotfiles).

# Purpose
These files are for my own use. I try to keep things as vanilla as possible except for the rare things I have strong opinions on. This works for me, but likely won't for you. Specific settings aside, these files might be suitable for you if you:

- want to be portable,
- respect the default config path of your apps,
- respect the default settings and only change them when necessary,
- use similar apps.

# Method
I've tried [GNU Stow](https://www.gnu.org/software/stow) and [chezmoi](chezmoi.io) before but they were overly complicated for what they're trying to accomplish. They also both required installing additional software. I wanted to avoid this because my needs are not complex. So I opted in for a solution I serendipitously came across on [Hacker News](https://news.ycombinator.com/item?id=11071754) and [Atlassian's documentation](https://www.atlassian.com/git/tutorials/dotfiles). 

The only software this method requires is git. In short, you create a bare git repository in your `$HOME`, then add your dotfiles files for versioning.

# Installation
## Starting from scratch
Create a folder named `.dotfiles` in your `$HOME`:

```bash
git init --bare $HOME/.dotfiles
```

Create an `alias` for `dotfiles` which will allow you to interact with `git` to configure your `.dotfiles` repository.

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Set a flag to hide the files you're not tracking. This is to prevent files from showing up as `untracked` when you use `dotfiles status` and other commands.

```bash
dotfiles config --local status.showUntrackedFiles no
```

Add the `alias` to the config file of the shell of your choice. The command below installs the alias to your `.zshrc` file.

```bash
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
```

Now you've successfully set things up. The only thing left is to add your dotfiles, which requires basic git knowledge. If you've followed the commands to a t, then you can use the examples below to stage, commit, and push your dotfiles.

```bash
dotfiles add .zshrc
dotfiles commit -m "Add .zshrc"
dotfiles push
```

Repeat these steps for the files you want to keep track on and you're done.

## Apply from a repository
Before you start, make sure your `alias` is set on your new machine.

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'{:.bash}
```

Use the command below so that your source repository ignores the folder where you will clone it.

```bash
echo ".dotfiles" >> .gitignore
```

You can now safely clone your dotfiles into a bare repository.

```bash
git clone --bare git-repo-url $HOME/.dotfiles
```

Define the alias for your `.dotfiles` folder.

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

Checkout the content from the bare repository to your `$HOME`.

```bash
dotfiles checkout
```

After this step, you may encounter an error message. This is because your `$HOME` folder might already have stock config files. To fix the issue, either back these files up, or delete them. Alternatively, you can use the commands below to back these files up to a folder.

```bash
mkdir -p .dotfiles-backup && \
dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .dotfiles-backup/{}
```

After you dealt with your stock config files run `dotfiles checkout` again. Then set `showUntrackedFiles` to `no` on your `.dotfiles` repository.

```bash
dotfiles config --local status.showUntrackedFiles no
```

That's it. No new software, no dependencies, no new commands to learn, no troubleshooting. Just git.

# Notes
Beware that some config paths are impossible to replicate, as in the case of [Firefox](https://github.com/aloglu/dotfiles/tree/main/dot_mozilla/private_firefox/private_8ynqsi72.default-release/chrome). In cases like this, just manually copy over the file.

<!-- Archives of Linked Sources
https://web.archive.org/web/20220429071157/https://news.ycombinator.com/item?id=11071754
https://web.archive.org/web/20220417080228/https://www.atlassian.com/git/tutorials/dotfiles
https://web.archive.org/web/20220502140347/https://bitbucket.org/durdn/cfg/raw/master/.bin/install.sh
-->
