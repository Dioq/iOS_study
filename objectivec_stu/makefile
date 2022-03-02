cc = clang
framework = Foundation
memory_management = -fobjc-arc
arch = x86_64

source = main.m
outfile = main

all:
	@${cc} ${memory_management} -arch ${arch} -framework ${framework} ${source} -o ${outfile}

clean:
	@-rm -rf ${outfile}
