sudo apt update && sudo apt install -y git cmake build-essential gcc g++ nasm curl unzip
git clone git@github.com:libjpeg-turbo/libjpeg-turbo.git
cd libjpeg-turbo
git checkout 3f43c6a
mkdir build_asan
cd build_asan
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DWITH_SIMD=1 -DCMAKE_C_FLAGS="-fsanitize=address -g" ..
make -j$(nproc)
curl -L -o poc_tmin124.zip "https://github.com/libjpeg-turbo/libjpeg-turbo/files/11072517/poc_tmin124.zip?raw=true"
unzip poc_tmin124.zip
./djpeg -nosmooth ./poc_tmin124