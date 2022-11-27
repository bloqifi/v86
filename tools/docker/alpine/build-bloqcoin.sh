#/bin/sh
cd /root
git clone https://github.com/bloqcoin/bloqcoin.git
cd bloqcoin
./autogen.sh
./configure --prefix=/opt/bloqcoin --libdir=/opt/bloqcoin/lib CXXFLAGS="-std=c++14" --disable-wallet --without-gui --disable-zmq --enable-cxx --disable-shared --with-pic --disable-tests --disable-bench
make
make install
rm -rf /root/bloqcoin