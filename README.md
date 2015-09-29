# Simple SSH Config Updater 
So it's a little bash script I wrote to help quickly update SSH config files. I found that I was frequently vim'ing and grepping my config for servers I didn't use very often. This script is an attempt to speed up those interactions.

I added the removal ability because I wanted to have a play with sed and see what could be done. 

## Alias 
Usage is probably best by alias, pull the code and alias to script. e.g from my bash_profile:

    alias scu='/path/to/repo/ssh_config_updater.sh'
  
Then invocation is simply `$ scu`

## Requirements
This script has been written for bash and developed and tested on OS X. I will test it on more platforms if it becomes more useful but I use `sed` to process the removal which might not translate. You'll have to try for yourself. 




