debug:
	nim c -o:20$(year)/day$(day).out -r 20$(year)/day$(day).nim

fast:
	nim c -d:release -o:20$(year)/day$(day).out -r 20$(year)/day$(day).nim

danger:
	nim c -d:danger -o:20$(year)/day$(day).out -r 20$(year)/day$(day).nim

new: 20$(year)
	touch 20$(year)/day$(day).nim

20$(year):
	mkdir $@

.PHONY: clean

clean:
	rm -f 20*/day*.out *.log