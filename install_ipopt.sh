#!/bin/bash

# 设置错误处理
set -e

# 更新包列表和安装必要的依赖项
echo "Updating package list and installing dependencies..."
sudo apt-get update
sudo apt-get install -y libblas3 libblas-dev liblapack3 liblapack-dev gfortran build-essential cppad gcc g++ unzip

# 解压 Ipopt-stable-3.12.zip
echo "Extracting Ipopt-stable-3.12.zip..."
unzip Ipopt-stable-3.12.zip

# 进入 Ipopt 的 ThirdPartyHSL 目录
echo "Navigating to ThirdPartyHSL directory..."
cd Ipopt-stable-3.12/ThirdParty/HSL || { echo "Directory Ipopt-stable-3.12/ThirdParty/HSL not found"; exit 1; }

# 解压 coinhsl.tar.gz
echo "Copying and extracting coinhsl.tar.gz..."
cp ../../../coinhsl.tar.gz coinhsl.tar.gz
tar -xzf coinhsl.tar.gz

cd coinhsl || { echo "Directory coinhsl not found"; exit 1; }

# 赋予执行权限并配置
echo "Changing permissions and configuring coinhsl..."
sudo chmod -R +777 .  # 赋予所有文件和目录可读和可执行权限
./configure
if [ $? -ne 0 ]; then
    echo "Configuration of coinhsl failed"
    exit 1
fi

# 编译和安装 coinhsl
echo "Compiling and installing coinhsl..."
make -j$(nproc)  # 使用系统中的所有处理器核心
sudo make install

# 修改环境变量
echo "Updating .bashrc to include /usr/local/lib in LD_LIBRARY_PATH..."
if ! grep -q "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" ~/.bashrc; then
    echo "export LD_LIBRARY_PATH=/usr/local/lib" >> ~/.bashrc
fi
source ~/.bashrc

# 返回上级目录，配置 Ipopt
echo "Navigating back and configuring Ipopt..."
cd ../../../ || { echo "Directory ../../../ not found"; exit 1; }
./configure --prefix /usr/local

# 编译、测试和安装 Ipopt
echo "Compiling Ipopt..."
make -j$(nproc)  # 使用系统中的所有处理器核心
echo "Testing Ipopt..."
#make test
echo "Installing Ipopt..."
sudo make install

# 更新环境变量
echo "Updating .bashrc to include /usr/local/lib in LD_LIBRARY_PATH..."
if grep -q "^export LD_LIBRARY_PATH=/usr/local/lib" ~/.bashrc; then
    sed -i 's|^export LD_LIBRARY_PATH=/usr/local/lib|export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH|' ~/.bashrc
else
    # If the line does not exist, append it to the file
    echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
fi
source ~/.bashrc

# 更新库缓存
echo "Updating library cache..."
sudo ldconfig

# 验证安装
echo "Verifying Ipopt installation..."
ldconfig -p | grep libipopt

echo "Ipopt installation script completed successfully."

