# notflix
A super simple Netflix clone. No seriously.

Notflix is my take on "Just enough self-hosted Web Video." It does, in a fairly
succinct way, hosting of media that is mostly dependent on the resources of the
clients. It does no transcoding, and serves only one type of video(x.264 mp4's)
via HTML5. It relies on the user to supply data, and in a kind of wierd but easy
to understand format. Basically, you embed metadata into the filename. It's
intended to run as a standalone static site on a static httpd for streaming or
downloading media from a very low power device, I'm personally going to attempt
to use it on an Onion Omega2+ with an SD card as a sort of personal, portable
media library that can be served to many people, but which doesn't need an
actual internet connection. But it's also easy to use as a Docker container or
with any static web server.

To make this work, I wrote a collection of shell scripts. Some of them could be
considered primitives for generating pages with shell scripts, and some of them
organize those primitives to be useful.

  * m4gallery is the program which generates the home page and the video viewing
   pages(however, it calls m4page to generate the bulk of the viewing pages).
   [m4gallery](https://github.com/eyedeekay/m4gallery)
  * m4page generates the viewport and detailed description of of the video for
   the video viewing pages by calling metaname and formatting the output.
   [m4page](https://github.com/eyedeekay/m4page)
  * m4konvert is basically a helper script that tells ffmpeg to make sure that
   a video is an mp4 before serving it. It'll be slow on a low power device but
   it also won't have to do anything if you add videos in the right format in
   the first place. konvert-all automatically calls m4konvert on all subpages.
   [m4konvert](https://github.com/eyedeekay/m4konvert)
  * metaname parses the filenames and turns them into metadata. metavars turns
   metaname's output into a shell script. I'm going to make one that does json
   as well.
   [metaname](https://github.com/eyedeekay/metaname)
  * and of course Notflix is the packaging and deployment repository.
   [notflix](https://github.com/eyedeekay/notflix)

