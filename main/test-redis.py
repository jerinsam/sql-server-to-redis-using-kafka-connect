import redis

r=redis.Redis(host='redis', port= 6379,decode_responses=True)

r.set("Jerin","Sam")

print(r.get("Jerin"))
