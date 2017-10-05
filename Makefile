
containers: network minidlna syncthing tinc notflix viddir

run: viddir run-minidlna run-syncthing run-tinc run-notflix

update: update-minidlna update-syncthing update-notflix

allclean:
	rm -fv minidlna syncthing tinc notflix

all: containers run

clone:
	git clone https://github.com/eyedeekay/metaname
	git clone https://github.com/eyedeekay/m4page
	git clone https://github.com/eyedeekay/m4konvert
	git clone https://github.com/eyedeekay/m4gallery
	git clone https://github.com/eyedeekay/hdpage
	rm */*.mp4 */*/*.mp4

clean:
	rm -rfv metaname \
		m4page \
		m4konvert \
		m4gallery \
		hdpage \
		doc-pak \
		description-pak \
		minidlna \
		syncthing \
		tinc \
		notflix \
		viddir

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
	touch notflix

run-notflix:
	docker run --cap-drop=all \
		-d \
		--network notflix \
		--ip 172.18.0.2 \
		--hostname notflix \
		--add-host 'gateway-notflix:172.18.0.1' \
		--add-host 'notflix:172.18.0.2' \
		--add-host 'syncthing-notflix:172.18.0.3' \
		--add-host 'minidlna-notflix:172.18.0.4' \
		--add-host 'tinc-notflix:172.18.0.5' \
		--restart=always \
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
	docker rm -f notflix syncthing-notflix minidlna-notflix tinc-notflix; \
	docker rmi -f notflix syncthing-notflix minidlna-notflix tinc-notflix; \
	netclean; \
	true

update-js:
	docker cp search.js notflix:search.js

update-minidlna:
	docker rmi -f minidlna-notflix;
	make minidlna
	docker rm -f minidlna-notflix
	make run-minidlna

minidlna:
	docker build --force-rm -f Dockerfile.minidlna -t minidlna-notflix .
	touch minidlna

run-minidlna:
	docker run --cap-drop=all \
		-d \
		--network notflix \
		--ip 172.18.0.4 \
		--hostname minidlna-notflix \
		--add-host 'gateway-notflix:172.18.0.1' \
		--add-host 'notflix:172.18.0.2' \
		--add-host 'syncthing-notflix:172.18.0.3' \
		--add-host 'minidlna-notflix:172.18.0.4' \
		--add-host 'tinc-notflix:172.18.0.5' \
		--restart=always \
		--volume "$(shell pwd)/Videos:/home/dlna/videos" \
		-p 1900:1900/udp \
		-p 8200:8200 \
		-p 7680:8080 \
		--name minidlna-notflix -t minidlna-notflix

backup-syncthing:
	docker cp syncthing-notflix:/home/sync/.config/syncthing config-syncthing

update-syncthing:
	make backup-syncthing
	docker rmi -f syncthing-notflix;
	make syncthing
	docker rm -f syncthing-notflix;
	make run-syncthing

syncthing:
	docker build --force-rm -f Dockerfile.syncthing -t syncthing-notflix .
	touch syncthing

run-syncthing:
	docker run --cap-drop=all \
		-d \
		--network notflix \
		--ip 172.18.0.3 \
		--hostname syncthing-notflix \
		--add-host 'gateway-notflix:172.18.0.1' \
		--add-host 'notflix:172.18.0.2' \
		--add-host 'syncthing-notflix:172.18.0.3' \
		--add-host 'minidlna-notflix:172.18.0.4' \
		--add-host 'tinc-notflix:172.18.0.5' \
		--restart=always \
		-p 7684:8384 \
		--volume "$(shell pwd)/Videos:/home/dlna/Sync/videos" \
		--name syncthing-notflix -t syncthing-notflix

tinc:
	docker build --force-rm -f Dockerfile.tinc -t tinc-notflix .
	touch tinc

run-tinc:
	docker run --cap-drop=all \
		--cap-add NET_ADMIN \
		--device=/dev/net/tun \
		--network notflix \
		--ip 172.18.0.5 \
		--hostname tinc-notflix \
		--add-host 'gateway-notflix:172.18.0.1' \
		--add-host 'notflix:172.18.0.2' \
		--add-host 'syncthing-notflix:172.18.0.3' \
		--add-host 'minidlna-notflix:172.18.0.4' \
		--add-host 'tinc-notflix:172.18.0.5' \
		--restart=always \
		-p 7655:655 \
		-p '7655:655/udp' \
		--name tinc-notflix -t tinc-notflix

update-tinc:

network:
	sudo ip address add 192.168.1.11 dev wlan0
	docker network create --subnet=172.18.0.0/16 notflix
	make netclear

netclear:
	@echo 'sudo ip address del 192.168.1.11/32 dev wlan0' | tee network
	@echo 'docker network rm notflix' | tee -a network

netclean:
	sudo ip address del 192.168.1.11/32 dev wlan0; \
	docker network rm notflix; \
	rm network

viddir:
	mkdir -p "$(shell pwd)/Videos"
	touch viddir
