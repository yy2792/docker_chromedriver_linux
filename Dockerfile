# Use Python 3
FROM scrapinghub/scrapinghub-stack-scrapy:1.3-py3
ENV TERM xterm

# Your scrapy settings
ENV SCRAPY_SETTINGS_MODULE XXX.settings
RUN mkdir -p /app
WORKDIR /app

# Your requirements file
COPY ./requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


###
RUN apt-get install -y wget xvfb unzip

# Set up the Chrome PPA
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Update the package list and install chrome
RUN apt-get update -y
RUN apt-get install -y google-chrome-stable
RUN apt-get install xvfb

# Set up Chromedriver Environment variables
ENV CHROMEDRIVER_VERSION 2.46
ENV CHROMEDRIVER_DIR /chromedriver
RUN mkdir $CHROMEDRIVER_DIR

# Download and install Chromedriver
RUN wget -q --continue -P $CHROMEDRIVER_DIR "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
RUN unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR
RUN rm $CHROMEDRIVER_DIR/chromedriver_linux64.zip
RUN chmod -R 777 $CHROMEDRIVER_DIR/chromedriver

# Put Chromedriver into the PATH
ENV PATH $CHROMEDRIVER_DIR:$PATH
###

COPY . /app
RUN python setup.py install
