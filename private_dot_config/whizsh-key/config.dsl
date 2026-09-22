# Whizsh-key example configuration
# Format: <key>:<label>[:<command>]
# Submenus use 2-space indentation
# Hotkeys must be single alphanumeric characters [0-9a-zA-Z]
# Use {cursor} in commands to set cursor position after insertion

g:Git:
  s:Status:git status
  c:Commit:git commit -m "{cursor}"
  p:Push:git push
  l:Log:git log --oneline -20
  d:Diff:git diff
  a:Add all:git add -A
  g:lazygit:lazygit
  h:gh CLI:gh {cursor}
  r:Create PR:gh pr create

d:Docker:
  c:Containers:docker ps
  i:Images:docker images
  l:Logs:docker logs -f {cursor}
  b:Build:docker build -t {cursor} .
  r:Run:docker run -it {cursor}
  d:lazydocker:lazydocker

f:Files:
  l:List:ls -lah
  t:Tree:tree
  f:Find:fd . "{cursor}"
  g:Grep:rg -i "{cursor}"
  s:Sort:
    t:Time:ls -lah --sort time
    s:Size:ls -lah --sort size

n:Network:
  i:IP addr:ip addr
  s:Sockets:ss -tuln
  p:Ping:ping {cursor}
  c:Curl:
    p:Post:curl -X Post
    h:Headers:curl -I
  d:Dig:
    a:IP4:dig a
    m:MX:dig xm
    t:TXT:dig txt

s:System:
  b:btop:btop
  t:Top:top
  p:Processes:ps aux
  k:Kill PID:kill {cursor}
  g:Pgrep:pgrep -af {cursor}
  f:Memory:free -h
  d:Disk usage:df -h
  u:Dir size:du -sh {cursor}
  n:ncdu:ncdu
  l:Block devices:lsblk
  i:Uptime:uptime
  o:OS info:uname -a
  e:Kernel log:sudo dmesg

a:Archive:
  c:tar create:tar czvf {cursor}
  x:tar extract:tar xzvf {cursor}
  g:gzip:gzip {cursor}
  u:gunzip:gunzip {cursor}
  z:zip:zip {cursor}
  n:unzip:unzip {cursor}

m:Tmux:
  n:new session:tmux new -s {cursor}
  a:attach:tmux attach -t {cursor}
  k:kill session:tmux kill-session -t {cursor}

r:Reload config:whizsh-key-reload
v:Validate config:whizsh-key-validate
