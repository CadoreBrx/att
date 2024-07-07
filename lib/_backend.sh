#!/bin/bash
# 
# functions for setting up app backend

#######################################
# creates docker db
# Arguments:
#   None
#######################################
backend_db_create() {
  print_banner
  printf "${WHITE} 💻 Criando banco de dados...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  usermod -aG docker deployplw
  docker run --name ${folder_name}-postgresql \
                -e POSTGRES_USER=${folder_name}zpro \
                -e POSTGRES_PASSWORD=${pg_pass} \
				-e TZ="America/Sao_Paulo" \
                -p ${pg_port}:5432 \
                --restart=always \
                -v /data:/var/lib/postgresql/data-${folder_name} \
                -d postgres

  docker run --name ${folder_name}-redis-zpro \
                -e TZ="America/Sao_Paulo" \
                -p ${redis_port}:6379 \
                --restart=always \
                -d redis:latest redis-server \
                --appendonly yes \
                --requirepass "${redis_pass}"
EOF

  sleep 2
}

#######################################
# sets environment variable for backend.
# Arguments:
#   None
#######################################
backend_set_env() {
  print_banner
  printf "${WHITE} 💻 Configurando variáveis de ambiente (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  # ensure idempotency
  backend_url=$(echo "${backend_url/https:\/\/}")
  backend_url=${backend_url%%/*}
  backend_url=https://$backend_url

  # ensure idempotency
  frontend_url=$(echo "${frontend_url/https:\/\/}")
  frontend_url=${frontend_url%%/*}
  frontend_url=https://$frontend_url

sudo su - deployplw << EOF
  cat <<[-]EOF > /home/deployplw/${folder_name}/zpro.io/backend/.env
NODE_ENV=
BACKEND_URL=${backend_url}
FRONTEND_URL=${frontend_url}
ADMIN_DOMAIN=zpro.io

PROXY_PORT=443
PORT=${backend_port}

# conexão com o banco de dados
DB_DIALECT=postgres
DB_PORT=${pg_port}
POSTGRES_HOST=localhost
POSTGRES_USER=${folder_name}zpro
POSTGRES_PASSWORD=${pg_pass}
POSTGRES_DB=postgres

# Chaves para criptografia do token jwt
JWT_SECRET=DPHmNRZWZ4isLF9vXkMv1QabvpcA80Rc
JWT_REFRESH_SECRET=EMPehEbrAdi7s8fGSeYzqGQbV5wrjH4i

# Dados de conexão com o REDIS
IO_REDIS_SERVER=localhost
IO_REDIS_PASSWORD=${redis_pass}
IO_REDIS_PORT=${redis_port}
IO_REDIS_DB_SESSION=2

#CHROME_BIN=/usr/bin/google-chrome
CHROME_BIN=/usr/bin/google-chrome-stable

# tempo para randomização da mensagem de horário de funcionamento
MIN_SLEEP_BUSINESS_HOURS=2500
MAX_SLEEP_BUSINESS_HOURS=5000

# tempo para randomização das mensagens do bot
MIN_SLEEP_AUTO_REPLY=2500
MAX_SLEEP_AUTO_REPLY=5000

# tempo para randomização das mensagens gerais
MIN_SLEEP_INTERVAL=250
MAX_SLEEP_INTERVAL=500

# api oficial (integração em desenvolvimento)
API_URL_360=https://waba-sandbox.360dialog.io

# usado para mosrar opções não disponíveis normalmente.
ADMIN_DOMAIN=zpro.io

# Dados para utilização do canal do facebook
FACEBOOK_APP_ID=3237415623048660
FACEBOOK_APP_SECRET_KEY=3266214132b8c98ac59f3e957a5efeaaa13500

# Limitar Uso do ZPRO Usuario e Conexões
USER_LIMIT=99
CONNECTIONS_LIMIT=99
[-]EOF
EOF

  sleep 2
}

#######################################
# installs node.js dependencies
# Arguments:
#   None
#######################################
backend_node_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependências do backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deployplw <<EOF
  cd /home/deployplw/${folder_name}/zpro.io/backend
  npm install --force
EOF

  sleep 2
}


#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_update() {
  print_banner
  printf "${WHITE} 💻 Atualizando o backend...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deployplw <<EOF
  cd /home/deployplw/${folder_name}/zpro.io/backend
  pm2 stop all
  npm r whatsapp-web.js
  npm i whatsapp-web.js
  pm2 restart all
EOF

  sleep 2
}

#######################################
# runs db migrate
# Arguments:
#   None
#######################################
backend_db_migrate() {
  print_banner
  printf "${WHITE} 💻 Executando db:migrate...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deployplw <<EOF
  cd /home/deployplw/${folder_name}/zpro.io/backend
  npx sequelize db:migrate
EOF

  sleep 2
}

#######################################
# runs db seed
# Arguments:
#   None
#######################################
backend_db_seed() {
  print_banner
  printf "${WHITE} 💻 Executando db:seed...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deployplw <<EOF
  cd /home/deployplw/${folder_name}/zpro.io/backend
  npx sequelize db:seed:all
EOF

  sleep 2
}

#######################################
# starts backend using pm2 in 
# production mode.
# Arguments:
#   None
#######################################
backend_start_pm2() {
  print_banner
  printf "${WHITE} 💻 Iniciando pm2 (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deployplw <<EOF
  cd /home/deployplw/${folder_name}/zpro.io/backend
  pm2 start dist/server.js --name ${folder_name}-zpro-backend
  pm2 save
EOF

  sleep 2
}

#######################################
# updates frontend code
# Arguments:
#   None
#######################################
backend_nginx_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando nginx (backend)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  backend_hostname=$(echo "${backend_url/https:\/\/}")

sudo su - root << EOF

cat > /etc/nginx/sites-available/${folder_name}-zpro-backend << 'END'
server {
  server_name $backend_hostname;

  location / {
    proxy_pass http://127.0.0.1:${backend_port};
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_cache_bypass \$http_upgrade;
  }
}
END

ln -s /etc/nginx/sites-available/${folder_name}-zpro-backend /etc/nginx/sites-enabled
EOF

  sleep 2
}
