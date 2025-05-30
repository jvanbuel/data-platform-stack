from trino.dbapi import connect

conn = connect(
    host="localhost",
    port=2000,
    user="admin",
)
cur = conn.cursor()
cur.execute("SELECT * FROM system.runtime.nodes")
rows = cur.fetchall()
print(rows)
print("Done")