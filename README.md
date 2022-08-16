<p align="center" >
<img src="https://github.com/nicolo-tellini/LICO/blob/main/lico3.png">
<p/>

# The Rational

Pipelines are logically organised workflows made up of tools and custom scripts. Serving code in an appropriate and reusable way is important to mantain the reproducibility of a scientific product and to provide the community with a way to face a problem task by task. 

> *"Computational analysis tools and pipelines should make the effort to be easily installable."* 

[Altuna Akalin](https://towardsdatascience.com/scientific-data-analysis-pipelines-and-reproducibility-75ff9df5b4c5) Bioinformatics Scientist.

The concept of installability is challenged by the ticking away of times because tools evolve and change constantly, that's it. 

> *"Linux is an operating system and its core is just a kernel. [...] We contribute at the rate of about [...] ten patches a day, twenty four hours a day, seven days a week, go into this code. It's constantly updated, constantly revised, constantly changing because the world changes. We have to react to a change in world. If an operating system stops change and of course if the world doesn't stop changing it will die. Linux constantly is improved, constantly is updated in order to handle the changing world.
"* 

[Greg Khroah-Hartman](https://en.wikipedia.org/wiki/Greg_Kroah-Hartman) fellow at The Linux Foundation.

# Description

Here, we present **LI**nk **CO**ntroller (**LICO**).
**LICO** is a schedulable utility for monitoring the link integrity and allows you to promptly identify broken links that crack the installation process of a pipeline.
**LICO** does test the integrity of the links that point to a specific version of a tools integrated into your pipeline. 
**LICO** operates silently in the background in a scheduled manner and returns a report to your Telegram account with info concerning the integrity of the links.
**LICO** relies on:

1) *cron*: a job scheduler;
2) *telegram-send*: a command-line tool to send messages over Telegram to your account.

While **cron** schedules the frequency at which you want to monitor the integrity of your links, **telegram-send** notifies you with a multi-message report.

NOTE: If you are not interested in sheduling/Telegram you can run ```monitorSR.sh```, instead. The output will be printed on the terminal. 

## ```monitor.sh``` and ```monitorSR.sh``` syntax:<br>

```
monitor.sh -h
Usage:
monitor.sh -l <file.txt> -p <rundir> -n <pipeline>
```

```<file.txt>```: a txt file with the GitHub/HTTP links (one link per line);<br>
<br>
```<rundir>```: path to ```/favorite/dir``` where ```file.txt``` is stored;<br>
<br>
```<pipeline>```: the name of your pipeline (to send you a meaningful report).<br>
<br>

NOTE: If you run ```monitorSR.sh``` you do not need to proceed further in this **README**.

# What you need

1. COPY ```monitor.sh``` inside your ```/favorite/dir ```<br>
note1: add +x permission to ```monitor.sh ```
2. CRON and TELEGRAM-SEND

## CRON and TELEGRAM-SEND installation
Install both [*cron*](https://www.digitalocean.com/community/tutorials/how-to-use-cron-to-automate-tasks-ubuntu-1804) and [*telegram-send*](https://pypi.org/project/telegram-send/) following the installation instructions,

## Create a BOT on Telegram
From the command line run 
  ```
telegram-send --configure
  ```
the steps to follow will be printed on the shell.

Be nice, say " Hi! " to your BOT, it is going to help you.

## Configure CRON
*cron* needs to know how frequently you want to run ```monitor.sh```.

Change the configuration file running ```crontab -e``` and add, for example:

```
0 0 1 */1 * monitor.sh <txt> <rundir> <pipeline>
```
note2: the script above assumes that ```/favorite/dir``` is in ```$PATH```.<br>
<br>
 ```0 0 1 */1 *``` specifies how frequently you want to monitor the link integrity. <br>
<br>
The searchbar at [CronTab.guru](https://crontab.guru/) allows you to set your favorite schedule up.<br>
<br>
Using this setup, ```monitor.sh``` will silently run in the background on the 1<sup>st</sup> of each month at midnight 🌕.<br>
<br>
note3: do not forget to specify ```SHELL``` and ```PATH``` inside *crontab* and make sure the file ends with a newline.<br>
<br>

 ```
SHELL=/bin/sh
PATH=/all/the/paths/in/your/$PATH

0 0 1 */1 * monitor.sh <listoflinks.txt> <rundir> <pipeline>

 ```
 
## Example

After the installation of the dependencies,

I locate  ```soft.txt``` and  ```monitor.sh``` in  ```/home/ntellini/LICO```.

 ```soft.txt``` contains :
```
https://github.com/rrwick/Filtlong.git
https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.6-6/GenomeAnalysisTK.jar
http://topaz.genetics.utah.edu/maker_downloads/static/maker-3.00.0-beta.tgz
http://eddylab.org/software/tRNAscan-SE/tRNAscan-SE.tar.gz
```
i.e. a GitHub repo, two broken links, and a working link.

My crontab looks like this:

```
SHELL=/bin/sh
PATH=/opt/def/anaconda3/bin:/opt/tvs/bin:/home/tools/bin:/home/ntellini/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/lib/mit/sbin:/snap/bin:/home/ntellini/LICO
*/5 * * * * monitor.sh soft.txt /home/ntellini/LICO sppcomp

```
The run will start in 5 min afetr saving the *crontab* confing file. <br>
<br>
note4: At the end of the run, remind to remove the folder with ```<pipeline>``` name inside your ```/favorite/dir``` (in my case/home/ntellini/LICO/sppcomp) before the next run starts. 

## The OUTPUT

At the end of the run, the bot sends the report to your Telegram account.

<p align="center" >
<img src="https://github.com/nicolo-tellini/LICO/blob/main/LICO_OK.png" width="375" height="800">
<p/>
  
The 4<sup>th</sup> message is the **MOST** important.<br>
 <br>
It tells us that, during the download of the packages: <br>
<br>
the packages ```Filtlong``` and  ```tRNAscan-SE.tar.gz``` have been successfully downloaded (```OK```) while, both ```GATK``` and ```maker``` downloads ended up with an error (```Exit```).

# RELEASE HISTORY

* v1.0.0 Released on 2023

# DEPENDENCIES

* [cron](https://packages.ubuntu.com/search?keywords=cron);
* [telegram-send](https://pypi.org/project/telegram-send/).
