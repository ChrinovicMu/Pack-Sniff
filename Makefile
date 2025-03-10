
CC := gcc
CFLAGS := -O2
LDFLAGS := -lpcap -pthread
SRC_DIR := src
TARGET := ./main

SRCS := $(wildcard $(SRC_DIR)/*.c)

.PHONY: build run clean

build:
	$(CC) $(CFLAGS) $(SRCS) -o $(TARGET) $(LDFLAGS)

run: build
	sudo $(TARGET)

clean:
	rm -f $(TARGET)

test: build
	valgrind --leak-check=full --track-origins=yes --show-leak-kinds=all --verbose ./main

perf: build 
	@echo "RUNNING perf on : $(TARGET)"
	sudo perf stat -e cache-misses,cache-references $(TARGET) > /dev/null 2>&1
	
.PHONY: git-push 
git-push:
	@git add .
	@read -p "commit msg : " msg; \
	git commit -m "$$msg"; \
	git push origin main 

