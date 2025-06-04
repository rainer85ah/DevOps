# Use official Node.js image
FROM node:20-alpine as builder
WORKDIR /app
COPY . .
RUN npm ci
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app ./
EXPOSE 3000
CMD [ "npm", "run", "start" ]