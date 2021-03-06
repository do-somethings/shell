#!/bin/bash

cd /usr/local/src/

if [ ! -f /usr/bin/bunzip2 ];then
    yum install -y bzip2
fi

if [ ! -f /usr/bin/git ];then
    yum install -y git
fi

[[ $? -ne 0 ]] && echo "Error: installing some of software" &&  exit $?

if [ ! -f v1.8.7.tar.gz ];then
	wget https://github.com/ethereum/go-ethereum/archive/v1.8.7.tar.gz
fi

if [ -s v1.8.7.tar.gz ]; then

tar zxvf v1.8.7.tar.gz
cd go-ethereum-1.8.7/
gmake all

cp -r build /srv/go-ethereum-1.8.7

fi

[[ $? -ne 0 ]] && echo "Error: gmake" &&  exit $?

#if [ $(id -u) != "0" ]; then
#    sudo make install
#else
#	make install
#fi

rm -f /srv/go-ethereum
ln -s /srv/go-ethereum-1.8.7 /srv/go-ethereum

[[ $? -ne 0 ]] && echo "Error: install" &&  exit $?

strip /srv/go-ethereum/bin/geth

cat > /etc/profile.d/go-ethereum.sh <<'EOF'
export PATH=$PATH:/srv/go-ethereum/bin
EOF

source /etc/profile.d/go-ethereum.sh

# cp /file{,.original}

#vim /srv/ <<end > /dev/null 2>&1
#:wq
#end

adduser ethereum