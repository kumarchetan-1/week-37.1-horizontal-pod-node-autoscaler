FROM oven/bun:1.2.2-slim

WORKDIR /app

COPY . .

RUN bun install

EXPOSE 3000

CMD ["bun", "index.ts"]