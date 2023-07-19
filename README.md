entry test 2 exercise 2 in bash script for develeap bootcamp

Exercise 0.2: Monitoring processes
Write a bash script called psping which checks periodically if a specific executable has a
live process. Following is the exact synopsis:
psping [-c ###] [-t ###] [-u user-name] exe-name
Counts and echos number of live processes for a user, whose executable file is exe-name.
Repeats this every second indefinitely, unless passed other specifications using switches:
-c - limit amount of pings, e.g. -c 3. Default is infinite
-t - define alternative timeout in seconds, e.g. -t 5. Default is 1 sec
-u - define user to check process for. Default is ANY user.
Following are some examples. All of them are based on a system that runs the following
processes:

UID CMD
jack /opt/google/chrome/chrome --type=-broker
jack /opt/google/chrome/chrome --type=zygote
mark /opt/google/chrome/chrome --type=-broker
mark /usr/bin/java my.jar -jar ~/project/chrome --render
root /sbin/init splash

jack@jacks-laptop:~$ psping java
Pinging ‘java’ for any user
java: 1 instance(s)...
Java: 1 instance(s)...
^C
What happened? Process java was found to be alive every second, until we pressed ctrl+c

jack@jacks-laptop:~$ psping -u mark -c 3 chrome
Pinging ‘chrome’ for user ‘mark’
chrome: 1 instance(s)...
chrome: 1 instance(s)...
chrome: 1 instance(s)...
What happened? Process chrome was found to be alive every second for 3 times. Note that
the program limited check to user marks’ processes AND was not fooled by the fact that the
java process had the word “chrome” in it’s command line.
Let assume that mark runs another instance of java as jack is running psping. This is how it
would look:

jack@jacks-laptop:~$ psping -t 5 -c 3 java
Pinging ‘java’ for any user
java: 1 instance(s)...
java: 2 instance(s)...
java: 2 instance(s)...
What happened? About 5-10 seconds AFTER jack ran psping, another java process was
started
