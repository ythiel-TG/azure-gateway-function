import azure.functions as func
import logging
import os
import jwt
import json


from app.main import business_logic  # both absolute and relative imports are possible for the Azure function


def main(req: func.HttpRequest, context: func.Context) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    name = req.params.get('name')
    env_variable = os.environ.get("MY_VARIABLE")

    decoded_token = jwt.decode('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c', options={"verify_signature": False})

    if name:
        return func.HttpResponse(
             f"Hello, {name}, {env_variable}. This HTTP triggered function executed successfully.",
             status_code=200
        )
    else:
        return func.HttpResponse(
             json.dumps(decoded_token),
             status_code=400
        )
