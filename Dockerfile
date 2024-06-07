##################################
#                                #
#       Alpine with nodejs       #
#                                #
##################################

FROM node:18.19.0-alpine3.18 AS node

##################################
#                                #
#   Alpine with custom libvips   #
#                                #
##################################

FROM libvips-custom-8.15.2 as base

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

RUN npm install -g pnpm && \
    apk update && \
    apk add --update python3 make g++

##################################
#                                #
#   Stage 1: Scaffold monorepo   #
#       Usage: prod & dev        #
#                                #
##################################

FROM base as builder

WORKDIR /app

COPY package.json pnpm-lock.yaml tsconfig.json ./
COPY assets/ ./assets/
COPY src/ ./src/

RUN pnpm install --frozen-lockfile

CMD ["pnpm", "run", "start"]