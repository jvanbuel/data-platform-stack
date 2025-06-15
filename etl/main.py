from trino.auth import OAuth2Authentication
from trino.dbapi import connect

conn = connect(
    host="trino.exoscale.playground.dataminded.cloud",
    port=443,
    http_scheme="https",
    user=None,
    auth=OAuth2Authentication(),
    verify=False,
)

cur = conn.cursor()
cur.execute("SELECT * FROM system.runtime.nodes")
rows = cur.fetchall()
print(rows)
print("Done")
