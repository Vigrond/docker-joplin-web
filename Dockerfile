FROM node:latest

# rsync required for `yarn install` package commands
RUN apt update && apt install -y jq rsync

# yarn no longer included with node
RUN npm install --global corepack && corepack enable

# get latest release tarball and extract to /source
WORKDIR /source
RUN curl -s https://api.github.com/repos/laurent22/joplin/releases/latest | jq -r '.tarball_url' | wget -qO - -i - | tar -xzvf -

# build web app
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN cd ./*/packages/app-mobile && yarn install && yarn web

# copy build to /app
WORKDIR /app
RUN cp -a /source/*/packages/app-mobile/web/dist/* .

# serve http on port 8080
EXPOSE 8080
CMD npx -y http-server . -p 8080
