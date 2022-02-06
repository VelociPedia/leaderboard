# VelociPedia - Leaderboards !

### Welcome !
I made that project from my need to have a clear view of the tracks I did, what I achieve, and how I'm ranked compared to others. While I was at it, I look for some friends. Finally, my needs lead me to have all data covered, and here is the project.

I also ~regret~ am thrilled that there are SO MANY tracks out there in Velocidrone, but I forget which one is which. Well. I don't regret it, it's AWESOME ! But that's why in the future, I'm planning to make some sort of wiki of tracks (Leaderboards first, but also custom) to find them nicely (Screenshots, Youtube walkthrought, ...).

I'm hoping that project will add more competition between pilots on featured tracks, eventually all of them, so we will all become better together.

For now, only leaderboard's tracks are supported, not custom one. However, if anyone would like to add some tracks/series for regular updates, please feel free to reach me by opening an issue or a PR.

### How am I supposed to use all these data ?

Well. Git Clone. Excel. Do whatever you want.

What is usefull to know :

- `collections/fullcolection.csv` gathers all the tracks. To make a new collection, just copypaste it in a new file in `collections/` and make a PR ! Or at least, provide it in the issue.

- in `leaderboards/collection/`, you'll find ranking for somes series. They are sorted so that first will be a pilot with all tracks completed (so you can be first by always being in the 190s). Note that "completed" means being in the top 200. The pilots are then separated by the sum of PBs accomplished on each track.

- in `pilots/collection/`, you'll find differents files for your name. They'll sum up your PBs (best, worse, oldest, spec, not in top 200)

- the raw data for spreadsheet exploitation and data processing will be found in `leaderboards/data/` and `pilots/data/`

- in your name doesnt appear in `pilots/collection/` nor `pilots/data`, that means you didn't completed enought tracks of a collection to be worth processing. Sorry. But you can do it yourself with the `./getpilot.zsh` file. Usage is `./getpilot [collection] [pilotname]`. If you don't know how to use it, you might want to look for *Windows Subsystem for Linux*, or simply open an issue.

---

### Disclaimer

I am not affilated to Velocidrone in any way, nor have I any right on its products.

Data processed here are public, and its access serves an original processing.

People are free to fork, use and modify the content of this repository, at the condition they are respectful of the licence.

I *will not* distribute the script to gather data to prevent abuse to the velocidrone.com domain. That is why I totally consider that in my requests, and don't even trying to hide myself of that, and I am respecting a consequent delay between each request.
