# Base image
FROM --platform=linux/amd64 node:18

# Create app directory
WORKDIR /

VOLUME /src/shared

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

RUN apt-get update && apt-get -y install cmake
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb 
RUN apt-get update
RUN apt-get -y install nvidia-container-toolkit
RUN apt-get -y install cuda-toolkit-12-6
RUN export CUDA_HOME=/usr/local/cuda
RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64
RUN export PATH=$PATH:$CUDA_HOME/bin
RUN export CUDACXX=/usr/local/cuda-12.6/bin/nvcc
# Install app dependencies
RUN npm install --legacy-peer-deps

#build llama.cpp
RUN CUDACXX=/usr/local/cuda-12.6/bin/nvcc CMAKE_ARGS="-DLLAMA_CUBLAS=on -DCMAKE_CUDA_ARCHITECTURES=native" FORCE_CMAKE=1  npx --no node-llama-cpp download --cuda

# Bundle app source
COPY . .

# Creates a "dist" folder with the production build
RUN npm run build

# Start the server using the production build
CMD [ "node", "dist/main.js" ]
