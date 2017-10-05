
containers: minidlna syncthing notflix viddir

run: viddir run-minidlna run-syncthing run-notflix

all: containers run

clone:
	git clone https://github.com/eyedeekay/metaname
	git clone https://github.com/eyedeekay/m4page
	git clone https://github.com/eyedeekay/m4konvert
	git clone https://github.com/eyedeekay/m4gallery
	git clone https://github.com/eyedeekay/hdpage
	rm */*.mp4 */*/*.mp4

clean:
	rm -rf metaname \
		m4page \
		m4konvert \
		m4gallery \
		hdpage \
		doc-pak \
		description-pak

install: clean clone
	mkdir -p /usr/lib/notflix \
		/usr/share/doc/m4gallery \
		/usr/share/doc/m4konvert \
		/usr/share/doc/m4page \
		/usr/share/doc/metaname \
		/usr/share/doc/notflix
	install m4gallery/m4gallery /usr/local/bin
	install m4gallery/README.md /usr/share/doc/m4gallery
	install m4konvert/m4konvert /usr/local/bin
	install m4konvert/konvert-all /usr/local/bin
	install m4konvert/README.md /usr/share/doc/m4konvert
	install m4page/m4page /usr/local/bin
	install m4page/README.md /usr/share/doc/m4page
	install script.js /usr/lib/notflix
	install search.js /usr/lib/notflix
	install style.css /usr/lib/notflix
	install metaname/metaname /usr/local/bin
	install metaname/README.md /usr/share/doc/metaname
	install metaname/metavars /usr/local/bin
	install hdpage/hdpage /usr/local/bin
	install README.md /usr/share/doc/notflix

checkinstall:
	checkinstall --install=no -y \
		--maintainer=problemsolver@openmailbox.org \
		--pkgname=notflix \
		--requires=ffmpeg,markdown \
		--pkgversion=1 \
		--pkgrelease=1 \
		--pkglicense=gpl \
		--pkggroup=web \
		--pkgsource=./ \
		--deldoc=yes \
		--deldesc=yes \
		--delspec=yes \
		--backup=no \
		--pakdir=../

notflix:
	docker build --force-rm -t notflix .

run-notflix:
	docker run --cap-drop=all \
		-d \
		--restart=yes \
		--volume "$(shell pwd)/Videos:/home/notflix/videos" \
		-p 7670:8080 \
		--name notflix \
		-t notflix

pages:
	docker exec -t notflix rm contents.md; \
	docker exec -t notflix m4gallery
	docker exec -t notflix cp style.css script.js search.js db

update-notflix:
	docker rm -f notflix; \
	make notflix
	make run-notflix
	make pages

clobber:
	docker rm -f notflix syncthing-notflix minidlna-notflix; \
	docker rmi -f notflix syncthing-notflix minidlna-notflix; \
	true

update-js:
	docker cp search.js notflix:search.js

update-minidlna:

minidlna:
	docker build --force-rm -f Dockerfile.minidlna -t minidlna-notflix .

run-minidlna:
	docker run --cap-drop=all \
		-d \
		--restart=yes \
		--volume "$(shell pwd)/Videos:/home/dlna/videos" \
		-p 1900:1900 \
		-p 8200:8200 \
		-p 7680:8080 \
		--name minidlna-notflix -t minidlna-notflix

update-syncthing:
	docker cp syncthing-notflix:/home/sync/.config/syncthing .
	docker rm -f syncthing-notflix; docker rmi -f syncthing-notflix;
	make syncthing
	make run-syncthing

syncthing:
	docker build --force-rm -f Dockerfile.syncthing -t syncthing-notflix .

run-syncthing:
	docker run --cap-drop=all \
		-d \
		--restart=yes \
		-p 7684:8384 \
		--volume "$(shell pwd)/Videos:/home/dlna/Sync/videos" \
		--name syncthing-notflix -t syncthing-notflix


viddir:
	mkdir -p "$(shell pwd)/Videos"
