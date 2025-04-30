# --- REMOTE TRACKING BRANCHES ---

# Step 0) Clean the worktree of master branch,
# i.e. ensure there are no uncommitted changes (local) and no unpushed commits (remote)
git status # (if there are uncommitted changes, you can either commit them or stash them)
     # nothing to commit, working tree clean
git log --oneline
     # bd03dde (HEAD -> master, origin/master, origin/HEAD) rebuilt on Wed Apr 30 21:30:02 CEST 2025

# ---- FETCH & MERGE CHANGES FROM THE REMOTE ----
# Step 1) Switch to master and update it from origin
git checkout master
# Fetch the latest changes from the remote repository
git fetch origin master # (or git pull origin master )

# --- CREATE/SWITCH TO A NEW WORKING BRANCH ---
# git checkout -b wkg_br
# Step 2) Switch to your working branch
git switch wkg_br

# Step 3a) Rebase your working branch onto the updated master (LINEAR but UNSAFE)
# git rebase master
# Step 3b) Merge your working branch onto the updated master (SAFE for collab)
git merge master

# Step 4) Stage and commit your changes (edit as needed)
git status # to see what I changed
git add .
git commit -m "WIP: update working branch with new changes" || true

# check differences (now the branch has deviated from origin/master)
git diff --color-words origin/master..wkg_br # (or git diff master..wkg_br)

# Step 5) Push your changes to the remote branch (set upstream if needed)
# git push <remote> <source>:<destination>
git push -u origin wkg_br

# Step 6) Create a pull request on GitHub
#     # this shows the changes you made in the wkg_br branch compared to the master branch
# 1/2) Use the botton "merge and rebase" on GH
# 2/2) merge and rebase
    #Step 1 Clone the repository or update your local repository with the latest changes.
    git pull origin master
    #Step 2 Switch to the base branch of the pull request.
    git checkout master
    #Step 3 Merge the head branch into the base branch.
    git merge wkg_br
    #Step 4 Push the changes.
    git push -u origin master

# --- verify branches ---
git branch -vv # * wkg_br abc1234 [origin/wkg_br] your commit message here
git log --graph --all --oneline --decorate








# --- Ensure that your local branches are always tracking their remote counterparts ---
git config --global push.autoSetupRemote true
# so you don’t need to explicitly use -u (or --set-upstream) every time.
# (without this, when you create a new branch (git checkout -b new-feature) and push it (git push), Git might respond that "The current branch new-feature has no upstream branch."")

