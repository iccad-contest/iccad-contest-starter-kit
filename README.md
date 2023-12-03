# ICCAD Contest Starter Kit


## Description

The code repository contains the starter kit for the [ICCAD Contest Platform](https://github.com/iccad-contest/iccad-contest-platform).

Regarding the const information, please refer it to [Problem C @ ICCAD Contest](https://dl.acm.org/doi/10.1145/3508352.3561109).


## Overview

[1. Starter Kit Structure](#1-starter-kit-structure)  
[2. Submission Site](#2-submission-site)  
[3. Instructions for Local Experiments](#3-instructions-for-local-experiments)  
[4. Instructions for Submissions on the Website](#4-instructions-for-submissions-on-the-website)  
[5. Release Time for the Ranking List](#5-release-time-for-the-ranking-list)  
[6. Contact](#6-contact)  


## 1. Starter Kit Structure

The entire starter kit structure is as shown below.

```
iccad-contest-starter-kit
├── LICENSE
├── README.md
├── env.yml
├── environment.txt            # server environment settings
├── evaluate-submission.sh
├── example-submissions        # example submissions
│   ├── cadc4444
│   │  ├── cadc4444.py
│   │  └── num-of-query.txt
│   ├── cadc5555
│   │  ├── cadc5555.py
│   │  └── num-of-query.txt
│   ├── cadc6666
│   │  ├── cadc6666.py
│   │  ├── configs.json
│   │  ├── num-of-query.txt
│   │  └── requirement.txt
│   ├── cadc7777
│   │  ├── cadc7777.py
│   │  ├── gp-configs.json
│   │  └── num-of-query.txt
│   ├── cadc8888
│   │  ├── cadc8888.py
│   │  └── num-of-query.txt
│   └── cadc9999
│      ├── cadc9999.py
│      └── num-of-query.txt
├── prepare-upload.sh          # preparation for submission upload
└── run-local.sh               # local experiments running script
```

Highlights of the contest platform:

* `example-submissions`: example submissions.
* `environment.txt`: server environment settings. The server is used to evaluate submissions.
* `prepare-upload.sh`: preparation for submission upload.
* `run-local.sh`: local experiments running script.


## 2. Submission Site

The [submission site](http://47.93.191.38/) is maintained for the long term.

If you do not have an account on the [submission site](http://47.93.191.38/), please follow the website guidelines to register a new account.

The [ranking list](http://47.93.191.38/ranking/) is determined using the real dataset, where we test your optimizer automatically without any human intervention.
The experiments will be repeated using pre-determined secret UUIDs, and the ranking list is based on the average results of the experiments.

Check `example-submissions` to see examples of submissions.
The examples currently contain the sub-directories, as shown below.

```console
example-submissions
├── cadc4444
│     ├── cadc4444.py
│     └── num-of-query.txt
├── cadc5555
│     ├── cadc5555.py
│     └── num-of-query.txt
├── cadc6666
│     ├── cadc6666.py
│     ├── configs.json
│     ├── num-of-query.txt
│     └── requirement.txt
├── cadc7777
│     ├── cadc7777.py
│     ├── gp-configs.json
│     └── num-of-query.txt
├── cadc8888
│     ├── cadc8888.py
│     └── num-of-query.txt
└── cadc9999
    ├── cadc9999.py
    └── num-of-query.txt
```
  These example directories, *e.g.*, cadc4444, *etc.*, are for the demonstration only.


## 3. Instructions for Local Experiments

Local experiments on the **dummy** dataset can be done using `run-local.sh`, powered by the [ICCAD Contest Platform](https://github.com/iccad-contest/iccad-contest-platform).
Note that these are not the same datasets on the ranking list when you submit your answers on the website, but they may be helpful for local practice and debugging.

The script `run-local.sh` can do local experiments conveniently in a single command.
Check the help menu via the `-h` option.

```bash
$ ./run-local.sh -h
Run ICCAD Contest Platform Locally.

Usage: ./run-local.sh [-h] [-o optimizer] [-u uuid] [-q num-of-queries]
options:
-h     print the help menu.
-o     optimizer specification.
       e.g., '-o cadc4444' specifies the cadc4444 under example-submissions/cadc4444
       if you have a JSON configuration file, the script can automatically specify it.
       NOTICE: the optimizer entry file name should be the same as the folder name under example-submissions.
-u     uuid specification. (optional)
```

The script produces a lot of log outputs when the experiment is running.
The `-o optimizer specification` (*e.g.*, `-o cadc4444`) specifies the *folder of the optimizer* which is under `example-submission`, while the `-u UUID` (*e.g.*, `-u "00ef538e88634ddd9810d034b748c24d"`) specifies the UUID to reproduce the experiment (UUID can be optional).
The Python script (*e.g.*, `cadc4444.py`) has the same name as the folder of the optimizer.
Under the folder of the optimizer, *num-of-query.txt* should be placed, the content of which specifies how many number of queries for your optimizer.

The arguments are utilized by the [ICCAD Contest Platform](https://github.com/iccad-contest/iccad-contest-platform).

An example is shown below.

```bash
$ ./run-local.sh -o cadc4444 -u "00ef538e88634ddd9810d034b748c24d"
/* ignore other output information */
summary for the solution, the best Pareto hypervolume: 37.59654046710655, cost: 164902.3422778734.


```


## 4. Instructions for Submissions on the Website

The quick-start instructions work as follows:

* Place all the necessary Python files in a folder, and name your optimizer with your team name, *e.g.*, `example-submissions/cadc6666`.
The [submission site](http://1.116.181.184/) will use `cadc6666.py` as the **entry point**.

* The Python environment will be `Python 3.8.8` and contain all dependencies specified in `environment.txt`.
All other dependencies must be placed in a `requirements.txt` in the same folder as `cadc6666.py`.

* The number of queries is specified in `num-of-query.txt` in the same folder as `cadc6666.py`.

The submission can be prepared using the `prepare-upload` script:

```bash
$ ./prepare-upload.sh -h
Prepare Your Submission for Upload.

Usage: ./prepare-upload.sh [-h] [-o optimizer]
options:
-h     print the help menu.
-t     team name specification.
```

Check the help menu via the `-h` option.

An example is shown below.
`./prepare-upload.sh` will produce a zip file (*e.g.*, `cadc6666.zip`) that can be uploaded on the [submission site](http://47.93.191.38/submit/).

```bash
$ ./prepare-upload.sh -t cadc6666
[INFO]: build the archive: example-submissions/cadc6666.zip of your submission for upload.
[INFO]: please upload the archive to http://47.93.191.38/submit/
[INFO]: please visit http://47.93.191.38/ranking/ to check the result.
```


## 5. Release Time for the Ranking List

The [ranking list](http://47.93.191.38/ranking/) is updated once your submission is evaluated completely.


## 6. Contact

Please contact **baichen.bai@alibaba-inc.com** or **baichen318@gmail.com** for any question, comment, or bug report.
