#!/bin/bash
set -e
if [[ "$VIRTUAL_ENV" == "" ]]
then
    echo "This Script must be run from within a virtualenv";
    exit 1;
fi

if type "curl" &> /dev/null;
then
    download="curl -O"
else
    download="wget -N"
fi

pkgver=${XAPIAN_VERSION:-1.2.19}
url=http://oligarchy.co.uk/xapian
xapian_core=$url/$pkgver/xapian-core-$pkgver.tar.xz
xapian_bind=$url/$pkgver/xapian-bindings-$pkgver.tar.xz
venv=$VIRTUAL_ENV

mkdir -p $venv/src && cd $venv/src

echo "Downloading $xapian_core..."
$download $xapian_core && tar xf xapian-core-$pkgver.tar.xz
echo "Downloading $xapian_bind..."
$download $xapian_bind && tar xf xapian-bindings-$pkgver.tar.xz

cd $venv/src/xapian-core-$pkgver

echo "Configuring Xapian Core..."
./configure --prefix=$venv >/dev/null || { echo "Configuration failed"; exit 1; }

echo "Building Xapian Core, this can take a while..."
make >/dev/null || { echo "Make failed"; exit 1; }

echo "Installing Xapian Core..."
make install >/dev/null || { echo "Installation failed"; exit 1; }

export LD_LIBRARY_PATH=$venv/lib

cd $venv/src/xapian-bindings-$pkgver

echo "Configureing Xapian Python Binding..."
./configure --prefix=$venv --with-python >/dev/null || { echo "Configuration failed"; exit 1; }

echo "Building Xapian Binding for Python, this can take a while..."
make >/dev/null || { echo "Make failed"; exit 1; }

echo "Installing Xapian Binding for Python..."
make install >/dev/null { echo "Installation failed"; exit 1; }

# Check if xapian is available in python
python -c"import xapian" && echo "Successfully installed Xapian with Python extensions"
