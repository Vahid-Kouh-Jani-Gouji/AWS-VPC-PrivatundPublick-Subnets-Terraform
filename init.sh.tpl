    #!/bin/bash
    set -x
    sudo apt update -y
    sudo apt-get install nginx -y
    sudo sytemctl enable nginx
    sudo systemctl start nginx

