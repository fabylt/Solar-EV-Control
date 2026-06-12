ARG BUILD_FROM=ghcr.io/hassio-addons/base:14.0.3
FROM $BUILD_FROM

# Install Node.js and npm (without heavy C++ build tools)
RUN apk add --no-cache nodejs npm

# Setup working directory
WORKDIR /app

# Copy dependency manifests
COPY package.json ./

# Install ONLY production dependencies to run the compiled Express server
# This avoids installing development dependencies like Tailwind, Vite and esbuild,
# completely bypassing any native architecture compilation issue on Raspberry Pi.
RUN npm install --omit=dev --no-audit --no-fund

# Copy the rest of the application files (including the pre-built dist/ folder)
COPY . .

# Make the run script executable
RUN chmod a+x /app/run.sh

CMD [ "/app/run.sh" ]
