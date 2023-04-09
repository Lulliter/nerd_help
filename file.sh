# REPO CREATION & MANAGEMENT


## ---1) in Github  (https://github.com/Lulliter/Configuration-R-git.git)
# Create a new REPO

## ---2) in terminal /Users/luisamimmi/GoogleDrive/Github/
# git clone https://github.com/Lulliter/Configuration-R-git.git

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

# CACHE CREDENTIALS [using R commands from shell]
# from (https://cfss.uchicago.edu/setup/git-configure/#cache-credentials-for-ssh)
# In order to push changes to GitHub, you need to authenticate yourself. That is,
# you need to prove you are the owner of your GitHub account. When you log in to
# GitHub.com from your browser, you provide your username and password to prove
# your identity. But when you want to push and pull from your computer, you cannot
# use this method. Instead, you will prove your identity using one of two methods.

R CMD BATCH helper.R


# - A) - Cache credentials for HTTPS
# With this method you will clone repositories using a regular HTTPS url like
# https://github.com/<OWNER>/<REPO>.git. You will need a personal access token (PAT)
# and use that as your credential for HTTPS operations.

## ---1) Run this code to that takes you to the web form to create a PAT.
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


