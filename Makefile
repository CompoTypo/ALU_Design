all: build run

build:
	iverilog -pfileline=1 -Isrc src/Alu.v -o bin/Alu

run:
	vvp bin/Alu

clean:
	rm ./bin/* 