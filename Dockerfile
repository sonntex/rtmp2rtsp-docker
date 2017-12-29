FROM ubuntu:16.04

MAINTAINER Nikolay Beloborodov <sonntex@gmail.com>

ENV GST_VER 1.12.3

RUN apt-get update && apt-get install -y \
        build-essential \
        autoconf \
        automake \
        cmake \
        flex \
        bison \
        python \
        wget \
        git \
        libgnutls-dev \
        liborc-dev \
        libglib2.0-dev \
        libjson-glib-dev \
        libsoup2.4-dev

COPY 0001-rtmpdump-fix-crash.patch /tmp

RUN cd /tmp \
    && git clone https://git.ffmpeg.org/rtmpdump \
    && cd rtmpdump \
    && git reset --hard fa8646d \
    && patch -p1 < ../0001-rtmpdump-fix-crash.patch \
    && rm ../*.patch \
    && sed -e 's/#CRYPTO=GNUTLS/CRYPTO=GNUTLS/' -i Makefile -i librtmp/Makefile \
    && make OPT="-O2" \
    && make prefix=/usr install \
    && cd - \
    && rm -rf rtmpdump

RUN rm /usr/lib/x86_64-linux-gnu/librtmp.so.1

RUN cd /tmp \
    && wget -O gstreamer-${GST_VER}.tar.xz \
        https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-${GST_VER}.tar.xz \
    && tar xvf gstreamer-${GST_VER}.tar.xz \
    && cd gstreamer-${GST_VER} \
    && ./configure \
        --prefix=/usr \
        --disable-static \
        --disable-gtk-doc \
        --disable-gtk-doc-html \
        --disable-gtk-doc-pdf \
        --disable-dependency-tracking \
        --disable-tests \
        --disable-failing-tests \
        --disable-benchmarks \
        --disable-check \
        --disable-examples \
        --disable-valgrind \
        --disable-debug \
    && make && make install \
    && cd - \
    && rm -rf gstreamer-${GST_VER}.tar.xz \
    && rm -rf gstreamer-${GST_VER}

RUN cd /tmp \
    && wget -O gst-plugins-base-${GST_VER}.tar.xz \
        https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${GST_VER}.tar.xz \
    && tar xvf gst-plugins-base-${GST_VER}.tar.xz \
    && cd gst-plugins-base-${GST_VER} \
    && ./configure \
        --prefix=/usr \
        --disable-static \
        --disable-gtk-doc \
        --disable-gtk-doc-html \
        --disable-gtk-doc-pdf \
        --disable-dependency-tracking \
        --disable-examples \
        --disable-valgrind \
        --disable-debug \
        --disable-adder \
        --enable-app \
        --disable-audioconvert \
        --disable-audiorate \
        --disable-audiotestsrc \
        --disable-encoding \
        --disable-videoconvert \
        --disable-gio \
        --disable-playback \
        --disable-audioresample \
        --disable-rawparse \
        --disable-subparse \
        --disable-tcp \
        --disable-typefind \
        --disable-videotestsrc \
        --disable-videorate \
        --disable-videoscale \
        --disable-volume \
        --disable-iso-codes \
        --disable-zlib \
        --disable-x \
        --disable-xvideo \
        --disable-xshm \
        --disable-alsa \
        --disable-cdparanoia \
        --disable-ivorbis \
        --disable-libvisual \
        --disable-ogg \
        --disable-opus \
        --disable-pango \
        --disable-theora \
        --disable-vorbis \
    && make && make install \
    && cd - \
    && rm -rf gst-plugins-base-${GST_VER}.tar.xz \
    && rm -rf gst-plugins-base-${GST_VER}

RUN cd /tmp \
    && wget -O gst-plugins-good-${GST_VER}.tar.xz \
        https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${GST_VER}.tar.xz \
    && tar xvf gst-plugins-good-${GST_VER}.tar.xz \
    && cd gst-plugins-good-${GST_VER} \
    && ./configure \
        --prefix=/usr \
        --disable-static \
        --disable-gtk-doc \
        --disable-gtk-doc-html \
        --disable-gtk-doc-pdf \
        --disable-dependency-tracking \
        --disable-examples \
        --disable-valgrind \
        --disable-debug \
        --disable-alpha \
        --disable-apetag \
        --disable-audiofx \
        --enable-audioparsers \
        --disable-auparse \
        --disable-autodetect \
        --disable-avi \
        --disable-cutter \
        --disable-debugutils \
        --disable-deinterlace \
        --disable-dtmf \
        --disable-effectv \
        --disable-equalizer \
        --enable-flv \
        --disable-flx \
        --disable-goom \
        --disable-goom2k1 \
        --disable-icydemux \
        --disable-id3demux \
        --disable-imagefreeze \
        --disable-interleave \
        --disable-isomp4 \
        --disable-law \
        --disable-level \
        --disable-matroska \
        --disable-monoscope \
        --disable-multifile \
        --disable-multipart \
        --disable-replaygain \
        --enable-rtp \
        --enable-rtpmanager \
        --enable-rtsp \
        --disable-shapewipe \
        --disable-smpte \
        --disable-spectrum \
        --enable-udp \
        --disable-videobox \
        --disable-videocrop \
        --disable-videofilter \
        --disable-videomixer \
        --disable-wavenc \
        --disable-wavparse \
        --disable-y4m \
        --disable-directsound \
        --disable-waveform \
        --disable-oss \
        --disable-oss4 \
        --disable-sunaudio \
        --disable-osx_audio \
        --disable-osx_video \
        --disable-gst_v4l2 \
        --disable-v4l2-probe \
        --disable-x \
        --disable-aalib \
        --disable-aalibtest \
        --disable-cairo \
        --disable-flac \
        --disable-gdk_pixbuf \
        --disable-jack \
        --disable-jpeg \
        --disable-libcaca \
        --disable-libdv \
        --disable-libpng \
        --disable-pulse \
        --disable-dv1394 \
        --disable-shout2 \
        --disable-soup \
        --disable-speex \
        --disable-taglib \
        --disable-vpx \
        --disable-wavpack \
        --disable-zlib \
        --disable-bz2 \
    && make && make install \
    && cd - \
    && rm -rf gst-plugins-good-${GST_VER}.tar.xz \
    && rm -rf gst-plugins-good-${GST_VER}

RUN cd /tmp \
    && wget -O gst-plugins-bad-${GST_VER}.tar.xz \
        https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${GST_VER}.tar.xz \
    && tar xvf gst-plugins-bad-${GST_VER}.tar.xz \
    && cd gst-plugins-bad-${GST_VER} \
    && ./configure \
        --prefix=/usr \
        --disable-static \
        --disable-gtk-doc \
        --disable-gtk-doc-html \
        --disable-gtk-doc-pdf \
        --disable-dependency-tracking \
        --disable-examples \
        --disable-valgrind \
        --disable-debug \
        --disable-accurip \
        --disable-adpcmdec \
        --disable-adpcmenc \
        --disable-aiff \
        --disable-videoframe_audiolevel \
        --disable-asfmux \
        --disable-audiobuffersplit \
        --disable-audiofxbad \
        --disable-audiomixer \
        --disable-audiomixmatrix \
        --disable-compositor \
        --disable-audiovisualizers \
        --disable-autoconvert \
        --disable-bayer \
        --disable-camerabin2 \
        --disable-coloreffects \
        --disable-debugutils \
        --disable-dvbsuboverlay \
        --disable-dvdspu \
        --disable-faceoverlay \
        --disable-festival \
        --disable-fieldanalysis \
        --disable-freeverb \
        --disable-frei0r \
        --disable-gaudieffects \
        --disable-geometrictransform \
        --disable-gdp \
        --disable-id3tag \
        --disable-inter \
        --disable-interlace \
        --disable-ivfparse \
        --disable-ivtc \
        --disable-jp2kdecimator \
        --disable-jpegformat \
        --disable-librfb \
        --disable-midi \
        --disable-mpegdemux \
        --disable-mpegtsdemux \
        --disable-mpegtsmux \
        --disable-mpegpsmux \
        --disable-mxf \
        --disable-netsim \
        --disable-onvif \
        --disable-pcapparse \
        --disable-pnm \
        --disable-rawparse \
        --disable-removesilence \
        --enable-sdp \
        --disable-segmentclip \
        --disable-siren \
        --disable-smooth \
        --disable-speed \
        --disable-subenc \
        --disable-stereo \
        --disable-timecode \
        --disable-videofilters \
        --enable-videoparsers \
        --disable-videosignal \
        --disable-vmnc \
        --disable-y4m \
        --disable-yadif \
        --disable-opengl \
        --disable-gles2 \
        --disable-egl \
        --disable-wgl \
        --disable-glx \
        --disable-cocoa \
        --disable-x11 \
        --disable-wayland \
        --disable-dispmanx \
        --disable-directsound \
        --disable-wasapi \
        --disable-direct3d \
        --disable-winscreencap \
        --disable-winks \
        --disable-android_media \
        --disable-apple_media \
        --disable-bluez \
        --disable-avc \
        --disable-shm \
        --disable-vcd \
        --disable-opensles \
        --disable-uvch264 \
        --disable-nvenc \
        --disable-tinyalsa \
        --disable-msdk \
        --disable-assrender \
        --disable-voamrwbenc \
        --disable-voaacenc \
        --disable-bs2b \
        --disable-bz2 \
        --disable-chromaprint \
        --disable-curl \
        --disable-dash \
        --disable-dc1394 \
        --disable-decklink \
        --disable-directfb \
        --disable-wayland \
        --disable-webp \
        --disable-daala \
        --disable-dts \
        --disable-resindvd \
        --disable-faac \
        --disable-faad \
        --disable-fbdev \
        --disable-fdk_aac \
        --disable-flite \
        --disable-gsm \
        --disable-fluidsynth \
        --disable-kate \
        --disable-kms \
        --disable-ladspa \
        --disable-lv2 \
        --disable-libde265 \
        --disable-libmms \
        --disable-srtp \
        --disable-dtls \
        --disable-ttml \
        --disable-modplug \
        --disable-mpeg2enc \
        --disable-mplex \
        --disable-musepack \
        --disable-neon \
        --disable-ofa \
        --disable-openal \
        --disable-opencv \
        --disable-openexr \
        --disable-openh264 \
        --disable-openjpeg \
        --disable-openni2 \
        --disable-opus \
        --disable-rsvg \
        --disable-gl \
        --disable-gtk3 \
        --disable-qt \
        --disable-vulkan \
        --disable-teletextdec \
        --disable-wildmidi \
        --disable-smoothstreaming \
        --disable-sndfile \
        --disable-soundtouch \
        --disable-spc \
        --disable-gme \
        --disable-dvb \
        --disable-acm \
        --disable-vdpau \
        --disable-sbc \
        --disable-schro \
        --disable-zbar \
        --enable-rtmp \
        --disable-spandsp \
        --disable-hls \
        --disable-x265 \
        --disable-webrtcdsp \
    && make && make install \
    && cd - \
    && rm -rf gst-plugins-bad-${GST_VER}.tar.xz \
    && rm -rf gst-plugins-bad-${GST_VER}

COPY 0001-rtsp-client-workaround-for-bad-clients.patch /tmp
COPY 0002-rtsp-stream-add-some-getters-for-multiudpsink.patch /tmp

RUN cd /tmp \
    && wget -O gst-rtsp-server-${GST_VER}.tar.xz \
        https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-${GST_VER}.tar.xz \
    && tar xvf gst-rtsp-server-${GST_VER}.tar.xz \
    && cd gst-rtsp-server-${GST_VER} \
    && patch -p1 < ../0001-rtsp-client-workaround-for-bad-clients.patch \
    && patch -p1 < ../0002-rtsp-stream-add-some-getters-for-multiudpsink.patch \
    && rm ../*patch \
    && ./configure \
        --prefix=/usr \
        --disable-static \
        --disable-gtk-doc \
        --disable-gtk-doc-html \
        --disable-gtk-doc-pdf \
        --disable-dependency-tracking \
        --disable-examples \
        --disable-valgrind \
        --disable-debug \
    && make && make install \
    && cd - \
    && rm -rf gst-rtsp-server-${GST_VER}.tar.xz \
    && rm -rf gst-rtsp-server-${GST_VER}

RUN cd /tmp \
    && git clone https://github.com/sonntex/rtmp2rtsp.git \
    && cd rtmp2rtsp \
    && git reset --hard c3c2f82 \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr \
    && make && make install \
    && cd - \
    && rm -rf rtmp2rtsp

ENV RTMP_HOST=172.17.0.1 \
    RTMP_PORT=1935 \
    RTMP_TIMEOUT=30 \
    RTSP_HOST=0.0.0.0 \
    RTSP_PORT=8554 \
    RTSP_TIMEOUT=30 \
    HTTP_HOST=0.0.0.0 \
    HTTP_PORT=8080 \
    PROMETHEUS_HOST=0.0.0.0 \
    PROMETHEUS_PORT=8081

EXPOSE ${RTSP_PORT} ${HTTP_PORT} ${PROMETHEUS_PORT}

COPY rtmp2rtsp-forever /usr/bin/rtmp2rtsp-forever

CMD rtmp2rtsp-forever
