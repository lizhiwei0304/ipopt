

```bash
sudo apt-get install libblas3 libblas-dev liblapack3 liblapack-dev gfortran build-essential cppad gcc g++
cd Ipopt-stable-3.12/ThirdParty/HSL
ln -s ../../../coinhsl/ coinhsl
cd coinhsl
sudo chmod +777 *
./configure
configure: Configuration of ThirdPartyHSL successful

make -j8
sudo make install
gedit ~/.bashrc
export LD_LIBRARY_PATH=/usr/local/lib
source ~/.bashrc 
cd ../../../
./configure --prefix /usr/local
make -j8
make test
sudo make install
gedit ~/.bashrc
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
source $HOME/.bashrc
sudo ldconfig
ldconfig -p | grep libipopt
```

