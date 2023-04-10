from pathlib import Path
import json

with open('./variables.json') as f:
   data = json.load(f)

with open("./aws/ecs/ecr_url.txt", "r") as file:
    ECR_URL = file.read()

file = Path('./templates/buildspec.yml')
file.write_text(file.read_text().replace('REPOSITORY_URL_VAR', ECR_URL))
file.write_text(file.read_text().replace('CONTAINER_NAME_VAR', data["project_name"]+"-Container"))