
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
	install m4page/script.js /usr/lib/notflix
	install m4page/style.css /usr/lib/notflix
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

docker:
	docker build --force-rm -t notflix .

run:
	docker run --cap-drop=all \
		-d \
		--volume "$(HOME)/Videos/notflix:/home/notflix/videos" \
		-p 7670:8080 \
		--name notflix \
		-t notflix

pages:
	docker exec -t notflix m4gallery

update:
	make docker
	docker rm -f notflix; \
	make run
	make pages

clobber:
	docker rm -f notflix; \
	docker rmi -f notflix; \
	docker system prune -f
