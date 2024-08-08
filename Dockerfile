# Usar uma imagem base do Node.js
FROM node:alpine

# Definir argumentos que podem ser usados para configurar o n8n
ARG N8N_VERSION=latest
ARG PGPASSWORD
ARG PGHOST
ARG PGPORT
ARG PGDATABASE
ARG PGUSER

ARG USERNAME
ARG PASSWORD
ARG ENCRYPTIONKEY

# Definir variáveis de ambiente baseadas nos argumentos
ENV N8N_ENCRYPTION_KEY=$ENCRYPTIONKEY
ENV DB_TYPE=postgresdb
ENV DB_POSTGRESDB_DATABASE=$PGDATABASE
ENV DB_POSTGRESDB_HOST=$PGHOST
ENV DB_POSTGRESDB_PORT=$PGPORT
ENV DB_POSTGRESDB_USER=$PGUSER
ENV DB_POSTGRESDB_PASSWORD=$PGPASSWORD

ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=$USERNAME
ENV N8N_BASIC_AUTH_PASSWORD=$PASSWORD

ENV N8N_USER_ID=root

# Instalar pacotes adicionais necessários
RUN apk add --update graphicsmagick tzdata

# Instalar o n8n (e agora também o turndown) globalmente
RUN apk --update add --virtual build-dependencies python3 build-base && \
    npm_config_user=root npm install --location=global n8n@${N8N_VERSION} turndown && \
    apk del build-dependencies

# Definir o diretório de trabalho para /data
WORKDIR /data

# Expor a porta definida pela variável ambiente PORT
EXPOSE $PORT

# Comando para iniciar o n8n, usando a variável ambiente PORT para definir a porta
CMD ["sh", "-c", "export N8N_PORT=$PORT && n8n start"]
