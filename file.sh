# see result in secret/SSH.md....

# REPO CREATION & MANAGEMENT


## ---1) in Github  (https://github.com/Lulliter/Configuration-R-git.git)
# Create a new REPO

## ---2) in terminal /Users/luisamimmi/GoogleDrive/Github/
git clone https://github.com/Lulliter/Configuration-R-git.git

## ---3) in terminal
git remote show origin # (get some information on its connection to GitHub(now master -> main!!!)
		# * remote origin
		#   Fetch URL: https://github.com/Lulliter/Regis_R.git
		#   Push  URL: https://github.com/Lulliter/Regis_R.git
		#   HEAD branch: master
		#   Remote branch:
		#     master tracked
		#   Local branch configured for 'git pull':
		#     master merges with remote master
		#   Local ref configured for 'git push':
		#     master pushes to master (up to date)


## ---4) make some loca changes
echo "A line I wrote on my local computer" >> README.md

## ---5) check what changed
git status
## ---6) Add to staging  + Commit (all) change(s)
			# git add README.md
			# git add Configuration-R-git.Rproj
			# git add         file.sh
			# git add        helper.R
			# git add        helper.Rout
git add -u

git commit -m "changed token"
## ---7) and push to your remote repo on GitHub.
git push origin master

# ----
# GITHUB AUTHENTICATION


# 1/2 CACHE CREDENTIALS *SSH*
# From https://docs.github.com/en/authentication/connecting-to-github-with-ssh
# When you connect via SSH, you authenticate using a private key file on your local machine


# a) Check if you have any SSH
ls -al ~/.ssh
			# total 40
			# drwx------    7 luisamimmi  staff   224 Sep  8  2017 .
			# drwxr-xr-x@ 105 luisamimmi  staff  3360 Jul 22 14:40 ..
			# -rw-------@   1 luisamimmi  staff  1766 Jun  6  2015 github_rsa
			# -rw-r--r--    1 luisamimmi  staff   401 Jun  6  2015 github_rsa.pub
			# -rw-r--r--@   1 luisamimmi  staff  2783 Sep  8  2017 known_hosts
			# -rw-------    1 luisamimmi  staff  3243 Feb 21  2018 id_rsa
			# -rw-r--r--@   1 luisamimmi  staff   746 Feb 21  2018 id_rsa.pub  # could be

# b) GENERATE NEW SSH key
ssh-keygen -t ed25519 -C "lmm76@georgetown.edu" # No location  # No passkey
# saved in /Users/luisamimmi/.ssh/id_ed25519

			# -rw-------@   1 luisamimmi  staff   411 Jul 22 14:45 id_ed25519
			# -rw-r--r--@   1 luisamimmi  staff   102 Jul 22 14:45 id_ed25519.pub

# c) ADD your SSH key to the ssh-agent
#Start the ssh-agent in the background.
eval "$(ssh-agent -s)" # Agent pid 77375
# exec ssh-agent zsh
open ~/.ssh/config
#If the file doesn't exist, create the file.
touch ~/.ssh/config
open ~/.ssh/config # then modify the file to contain the following lines.
			#Host github.com
			#  AddKeysToAgent yes
			#  UseKeychain yes
			#  IdentityFile ~/.ssh/id_ed25519

# d) ADD your SSH private key to the ssh-agent and store your passphrase in the keychain.
#If you created your key with a different name, or if you are adding an existing key that has a different name,
#replace id_ed25519 in the command with the name of your private key file.

# e) ssh-add --apple-use-keychain ~/.ssh/id_ed25519
ssh-add  ~/.ssh/id_ed25519 # IF no pass phrase
			# Identity added: /Users/luisamimmi/.ssh/id_ed25519 (lmm76@georgetown.edu)

# f) ADD the SSH public key to your account on GitHub.
# f.1) Copy the SSH public key to your clipboard.
pbcopy < ~/.ssh/id_ed25519.pub
# f.2) In the upper-right corner of any page, click your profile photo, then click Settings.

# g) PER CONFLITTI
#vedere https://github.blog/2023-03-23-we-updated-our-rsa-ssh-host-key/


# ---------


# 2/2 CACHE CREDENTIALS  *HTTPS* [using R commands from shell]
# from (https://cfss.uchicago.edu/setup/git-configure/#cache-credentials-for-ssh)
# In order to push changes to GitHub, you need to authenticate yourself. That is,
# you need to prove you are the owner of your GitHub account. When you log in to
# GitHub.com from your browser, you provide your username and password to prove
# your identity. But when you want to push and pull from your computer, you cannot
# use this method. Instead, you will prove your identity using one of two methods.

# install needed libraries in R
R CMD BATCH helper.R


# - A) - Cache credentials for HTTPS
# With this method you will clone repositories using a regular HTTPS url like
# https://github.com/<OWNER>/<REPO>.git. You will need a personal access token (PAT)
# and use that as your credential for HTTPS operations.

## ---1) Run this code that takes you to the web form to create a PAT.
# Use the pre-filled form and click “Generate token”.
Rscript -e 'usethis::create_github_token()' #helper function that takes you to the web form
			# NAME:  R:GITHUB_PAT Config — gist, repo, user, workflow
			# TOKEN:  ghp_...YzVa

## ---2) Store your PAT in R environ
Rscript -e 'usethis::edit_r_environ()' #which will open it
# write GITHUB_TOKEN="ghp_...YzVa" (in .Renviron)

		## (NOPE!)---2) Store your PAT with
		# (NOPE!) Rscript -e 'gitcreds::gitcreds_set()' # only works in interactive sessions

## ---3) Confirm your PAT is saved
Rscript -e 'gh::gh_whoami()' # YEP !


# ----

# - B) -  Set up keys for SSH
## --- List existing keys:
ls -al ~/.ssh/


