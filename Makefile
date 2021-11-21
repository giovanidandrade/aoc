debug:
	nim c -o:20$(year)/day$(day).out -r 20$(year)/day$(day).nim

fast:
	nim c -d:release -o:20$(year)/day$(day).out -r 20$(year)/day$(day).nim

danger:
	nim c -d:danger -o:20$(year)/day$(day).out -r 20$(year)/day$(day).nim

new:
	touch 20$(year)/day$(day).nim

.PHONY: clean

clean:
	rm -f 20*/day*.out *.log