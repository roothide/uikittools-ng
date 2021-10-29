SRC := $(wildcard *.po)

all: $(SRC:%.po=%.mo)

%.mo: %.po
	msgfmt -o $@ $<

clean:
	rm -f *.mo

install: all
	for lang in $(SRC:%.po=%); do \
		install -d $(DESTDIR)$(LOCALEDIR)/$$lang/LC_MESSAGES/; \
		install -m644 $$lang.mo $(DESTDIR)$(LOCALEDIR)/$$lang/LC_MESSAGES/uikittools-ng.mo || true; \
	done

.PHONY: all clean install
