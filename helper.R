# Configuration in R

print("Hello")

# Required pckgs ----------------------------------------------------------
if (!require("pacman")) {
	install.packages('pacman' )
}

pacman::p_load(usethis, gitcreds, gh)
