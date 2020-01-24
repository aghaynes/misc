## Github

![](figs/github.png)

Version control system, collaboration, R package repo.

Uses git in the background to enable version control.

Can have private or public repositories.

Really good for developing R packages 

* stable version on CRAN, development version 
* integrates with continuous integration
  * circleCI
  * travis-ci
  * appveyor
  * continuous integration rebuilds your package with each push
    * you know when something breaks
    * runs all of your tests
    * not exactly the same as the tests CRAN run, but better than nothing
* can install packages directly from github via `remotes::install_github` (also from bitbucket and others)
* really good for collaborating
  * each user/developer
    * forks the main repository
    * ![](figs/gitfork.png)
    * develops their parts in isolation
    * pushes the developments back to the master (more later)
    * ![](figs/gitpr.png)
    * can also pull more recent changes
  * ![](figs/gitbranch.png)
  
### What I do
1. fork/create a repo online
2. use cmd to clone it to my local machine
  * ![](figs/gitclone.png)
3. create a new branch (easiest within RStudio)
  * ![](figs/rs_branch.png)
  * if you're connected to the internet, the branch will automatically by pushed to github
4. make my changes
  * open files, add functionality/fix bugs/whatever
5. commit the changes
6. push the changes to github
7. happy?
  * yes! -> Make a pull request
  * no :( -> Make more changes
















