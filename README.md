Rundeck + Ansible plugin Docker image
==============================

Provides Docker image with Rundeck and Ansible based on Debian Buster. 

Build
---

```
./build.sh
```

Run
---

```
docker run -d -t \
  --name rundeck \
  -p 3306:3306 \
  -v /host/path/mysql:/var/lib/mysql \
  iape/mysql
```

Author
---
Andrey Makarov

Copyrights
---
© Iskratel Group, all rigths reserved.
