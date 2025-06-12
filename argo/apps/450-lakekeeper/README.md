# Create a warehouse in lakekeeper before reading data

cat <<EOF>> warehouse.json
{
"warehouse-name": "dataminded",
"storage-profile": {
"type": "s3",
"bucket": "<>",
"endpoint": "<>",
"key-prefix": "lakekeeper-dm",
"region": "<>",
"flavor": "aws-compat"
},
"storage-credential": {
"type": "s3",
"credential-type": "access-key",
"aws-access-key-id": "<>",
"aws-secret-access-key": "<>"
}
}
EOF

curl -X POST http://localhost:8181/management/v1/warehouse -H "Content-Type: application/json" -d warehouse.json
