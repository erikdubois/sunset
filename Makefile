# sunset - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: sunset

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

sunset: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f sunset ${OBJ}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f sunset ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/sunset

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/sunset
	rm /usr/share/xsessions/sunset.desktop

.PHONY: all clean install uninstall
