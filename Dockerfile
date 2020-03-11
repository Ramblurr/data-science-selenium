FROM jupyter/datascience-notebook

ENV CHROME_VER=79.0.3945.36
ENV FIREFOX_VER=v0.26.0


USER root

# Chrome and Firefox browsers
RUN apt-get update && \
	apt-get install -y gnupg && \
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
	sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
	apt-get update && apt-get install -y google-chrome-stable firefox vim openssl build-essential xorg libssl-dev xvfb wget xz-utils fontconfig libxrender1 libxext6 libx11-6  fonts-roboto fonts-noto; \
        rm -rf /var/lib/apt/lists/*


# chrome driver
RUN wget -q https://chromedriver.storage.googleapis.com/${CHROME_VER}/chromedriver_linux64.zip && \
	unzip -o chromedriver_linux64.zip && \
	rm chromedriver_linux64.zip && \
	mv chromedriver /usr/bin

#  firefox gecko driver
RUN wget -qO- https://github.com/mozilla/geckodriver/releases/download/${FIREFOX_VER}/geckodriver-${FIREFOX_VER}-linux64.tar.gz | tar -xvz -C /usr/bin

# wkhtmltopdf
RUN set -e; \
     wget https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    tar Jxf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    cp -r wkhtmltox/bin/* /usr/bin/ ; cp -r wkhtmltox/lib/* /usr/lib/ ; cp -r wkhtmltox/include/* /usr/include/ && \
    mkdir -p /usr/share/fonts/otf ; \
    wget https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/SourceHanSansJ.zip && \
    unzip SourceHanSansJ.zip ; mv SourceHanSansJ /usr/share/fonts/otf/ ; \
    wget https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/SourceHanSansHWJ.zip && \
    unzip SourceHanSansHWJ.zip ; mv SourceHanSansHWJ /usr/share/fonts/otf/ ; \
    wget https://github.com/adobe-fonts/source-han-sans/raw/release/SubsetOTF/SourceHanSansJP.zip && \
    unzip SourceHanSansJP.zip ; mv SourceHanSansJP /usr/share/fonts/otf/ ; \
    rm -f SourceHanSans*; fc-cache j; rm -rf /wkhtml* ; 

# pip requirements.txt
COPY requirements.txt /tmp/requirements.txt
RUN python -m pip install -r /tmp/requirements.txt
RUN python -m spacy download en_core_web_sm
RUN python -m nltk.downloader all

EXPOSE 8888

USER $NB_UID
