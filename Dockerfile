FROM debian:stable-slim

RUN apt-get update \
	&& apt-get install -y build-essential curl ca-certificates git hub vim \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl -sL -o /usr/local/bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme \
	&& chmod +x /usr/local/bin/gimme \
	&& curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash

CMD [ "/bin/bash" ]
