#!/usr/bin/python2.7

import sys
import time
import subprocess
from socket import socket

CARBON_SERVER = 'mon0.puppetlabs.lan'
CARBON_PORT = 2003

PROJECT_NAME = sys.argv[1]
REPO_PATH = sys.argv[2]
CLOC_CMD = ["/usr/bin/cloc",REPO_PATH,"--csv","--quiet","--progress-rate=0"]
LANG = "Ruby"

def get_cloc():
  cloc_result = subprocess.check_output(CLOC_CMD).splitlines()
  for line in cloc_result:
   if line and line.split(",")[1] == LANG:
    return line.split(",")

sock = socket()
try:
  sock.connect( (CARBON_SERVER,CARBON_PORT) )
except:
  print "Couldn't connect to %(server)s on port %(port)d, is carbon-agent.py running?" % { 'server':CARBON_SERVER, 'port':CARBON_PORT }
  sys.exit(1)

lines = []
cloc = get_cloc()
now = int( time.time() )
lines.append("sources.%(project)s.files %(result)s %(time)s" % {'project' : PROJECT_NAME, 'result' : cloc[0], 'time' : now})
lines.append("sources.%(project)s.blank %(result)s %(time)s" % {'project' : PROJECT_NAME, 'result' : cloc[2], 'time' : now})
lines.append("sources.%(project)s.comment %(result)s %(time)s" % {'project' : PROJECT_NAME, 'result' : cloc[3], 'time' : now})
lines.append("sources.%(project)s.code %(result)s %(time)s" % {'project' : PROJECT_NAME, 'result' : cloc[4], 'time' : now})
message = '\n'.join(lines) + '\n' #all lines must end in a newline
print "sending message\n"
print '-' * 80
print message
print
sock.sendall(message)
