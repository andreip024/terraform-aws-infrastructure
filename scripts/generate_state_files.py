import json

projects = ["infra", "elb", "ecs", "code"]

with open('./variables.json') as f:
   data = json.load(f)

for i in projects:
    f = open("./aws/" + i + "/" + i + ".config", "a")
    f.write('key="' + i + '.tfstate"\n')
    f.write('bucket="' + data["terraform"]["remote_state_bucket"] + '"\n')
    f.write('region="' + data["region"] + '"')
    f.close()

