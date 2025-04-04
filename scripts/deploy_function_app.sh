 zip -r build/function_app.zip \
 app/ function/ host.json requirements.txt \
 -x '*__pycache__*' \

az functionapp deployment source config-zip \
 --resource-group ythiel-test-gateway \
 --name ythieltfauthcheck-functions \
 --src build/function_app.zip \
 --build-remote true \
 --verbose
