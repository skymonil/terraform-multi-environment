#!/bin/bash
sudo su

# Install dependencies


# Get HCP creds from SSM (secure)
export HCP_CLIENT_ID=$(aws ssm get-parameter --name "/app/prod/HCP_CLIENT_ID" --with-decryption --query "Parameter.Value" --output text --region ap-south-1)
export HCP_CLIENT_SECRET=$(aws ssm get-parameter --name "/app/prod/HCP_CLIENT_SECRET" --with-decryption --query "Parameter.Value" --output text --region ap-south-1)

# Get temporary HCP access token
export HCP_API_TOKEN=$(curl --silent --location "https://auth.idp.hashicorp.com/oauth2/token" \
--header "Content-Type: application/x-www-form-urlencoded" \
--data-urlencode "client_id=$HCP_CLIENT_ID" \
--data-urlencode "client_secret=$HCP_CLIENT_SECRET" \
--data-urlencode "grant_type=client_credentials" \
--data-urlencode "audience=https://api.hashicorp.cloud" | jq -r .access_token)

# Fetch secret (DB connection string)
DB_CONN_STRING=$(curl --silent --location "https://api.cloud.hashicorp.com/secrets/2023-11-28/organizations/20b0be26-ec7c-4394-9a6b-2c8009beadce/projects/9d4b5f1e-0cc7-443b-84f2-362bf4916116/apps/caam/secrets:open" \
--request GET \
--header "Authorization: Bearer $HCP_API_TOKEN" | jq -r '.secrets[] | select(.name == "DB_CRED").static_version.value')

EMAIL_ID=$(curl --silent --location "https://api.cloud.hashicorp.com/secrets/2023-11-28/organizations/20b0be26-ec7c-4394-9a6b-2c8009beadce/projects/9d4b5f1e-0cc7-443b-84f2-362bf4916116/apps/caam/secrets:open" \
--request GET \
--header "Authorization: Bearer $HCP_API_TOKEN" | jq -r '.secrets[] | select(.name == "EMAIL_ID").static_version.value')

EMAIL_PASSWORD=$(curl --silent --location "https://api.cloud.hashicorp.com/secrets/2023-11-28/organizations/20b0be26-ec7c-4394-9a6b-2c8009beadce/projects/9d4b5f1e-0cc7-443b-84f2-362bf4916116/apps/caam/secrets:open" \
--request GET \
--header "Authorization: Bearer $HCP_API_TOKEN" | jq -r '.secrets[] | select(.name == "EMAIL_PASSWORD").static_version.value')

JWT_SECRET=$(curl --silent --location "https://api.cloud.hashicorp.com/secrets/2023-11-28/organizations/20b0be26-ec7c-4394-9a6b-2c8009beadce/projects/9d4b5f1e-0cc7-443b-84f2-362bf4916116/apps/caam/secrets:open" \
--request GET \
--header "Authorization: Bearer $HCP_API_TOKEN" | jq -r '.secrets[] | select(.name == "JWT_SECRET").static_version.value')

# Clone and run app
git clone https://github.com/skymonil/3-tier-architecture 
cd 3-tier-architecture/server
cd src
cat <<ENV_EOF > .env
MONGODB_URI=$DB_CONN_STRING
JWT_SECRET=$JWT_SECRET
EMAIL_PASSWORD=$EMAIL_PASSWORD
EMAIL_ID=$EMAIL_ID
ENV_EOF



npm install -g pm2
npm install
pm2 start app.js --name app
pm2 save
pm2 startup
