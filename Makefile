aoc:
	nim c -o:20$(year)/day$(day).out -r 20$(year)/day$(day).nim

new: 20$(year)/day$(day).nim
	touch 20$(year)/day$(day).nim

.PHONY: clean

clean:
	rm -f 20*/day*.out *.log