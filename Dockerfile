FROM node:latest

# rsync required for `yarn install` package commands
RUN apt update && apt install -y jq rsync

# yarn no longer included with node
RUN npm install --global corepack && corepack enable

# get latest release tarball and extract to /source
WORKDIR /source
RUN curl -s https://api.github.com/repos/laurent22/joplin/releases/latest | jq -r '.tarball_url' | wget -qO - -i - | tar -xzvf -

# build web app
WORKDIR /source/*/packages/app-mobile
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN yarn install && yarn web

# copy build to /app
WORKDIR /app
RUN cp -a /source/*/packages/app-mobile/web/dist .
