files := $(subst ./_,.,$(shell find . -name "_*" -maxdepth 1))

install: uninstall
		for file in $(files); do ln -s $(shell pwd)/$${file/./_} $$HOME/$$file; done

uninstall:
		-for file in $(files); do test -L $$HOME/$$file && rm $$HOME/$$file; done

.PHONY: install uninstall
