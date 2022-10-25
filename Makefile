all:
	sudo apt-get install -y git gnuplot python
	echo "Enter command 'make [ns-2, ns-3, mininet, julia, full]' to install all programs or part"
	
ns-2:
	sudo apt-get install -y nam
	sudo apt-get install -y ns2
ns-3:
	sudo apt-get install -y cmake
	wget https://www.nsnam.org/releases/ns-allinone-3.36.1.tar.bz2
	tar -xvf ./ns-allinone-3.36.1.tar.bz2
	cd ./ns-allinone-3.36.1 && ./build.py
	cp ./Imitation/NS3/pi.cc ./ns-allinone-3.36.1/ns-3.36.1/scratch/
	cp ./Imitation/NS3/dt.cc ./ns-allinone-3.36.1/ns-3.36.1/scratch/
mininet:
	sudo apt-get install -y python-tk xterm iperf3
	sudo apt-get install -y mininet
	git clone https://github.com/mininet/mininet
	cp ./mininet/examples/miniedit.py ./
julia:
	wget https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.0-linux-x86_64.tar.gz
	tar -xvf julia-1.8.0-linux-x86_64.tar.gz
	sudo cp -r julia-1.8.0 /opt/
	sudo ln -s /opt/julia-1.8.0/bin/julia /usr/local/bin/julia
full:
	make ns-2 ns-3 mininet julia clean
clean:
	rm -rf ./julia-1.8.0 
	rm -f ./julia-1.8.0-linux-x86_64.tar.gz
	rm -f ./ns-allinone-3.36.1.tar.bz2
	rm -rf ./mininet
