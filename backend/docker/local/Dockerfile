# Use Node.js 20 alpine as base image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Install pnpm (mandatory based on SDD)
RUN npm install -g pnpm

# Copy package files
COPY package.json pnpm-lock.yaml* ./

# Install dependencies
RUN pnpm install

# Expose NestJS port
EXPOSE 3000

# Command to run (using pnpm exec to ensure binaries in node_modules are found)
CMD ["pnpm", "exec", "nest", "start", "--watch"]
