ARG NODE_VERSION=18.14.2

# Menggunakan Node.js Alpine sebagai base image
FROM node:${NODE_VERSION}-alpine as base

# Install bash dan build tools jika diperlukan
RUN apk add --no-cache bash build-base

# Mendefinisikan variabel PORT dan ENV untuk container
ARG PORT=3003
ENV NODE_ENV=production

WORKDIR /src

# Build stage untuk melakukan instalasi dependencies dan build aplikasi
FROM base as build

COPY --link package.json package-lock.json .

# Instal dependencies dan bersihkan cache npm
RUN npm ci --production=false && npm cache clean --force

COPY --link . .

RUN npm run build

RUN npm prune --production && npm cache clean --force

# Menggunakan base image lagi untuk container runtime
FROM base

# Menetapkan port untuk aplikasi
ENV PORT=$PORT

# Menyalin hasil build dari stage build ke container runtime
COPY --from=build /src/.output /src/.output

# Menjalankan aplikasi Node.js
CMD [ "node", ".output/server/index.mjs" ]
