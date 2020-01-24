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
* really good for collaborating
  * each user/developer
    * forks the main repository
    * develops their parts in isolation
    * pushes the developments back to the master
    * can also pull more recent changes
    * ![https://v1study.com/git-branch.html](figs/gitbranch.png)
  

