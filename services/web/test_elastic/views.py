import os
from datetime import datetime
from django.http import HttpResponse
from elasticsearch import Elasticsearch

ELASTIC_HOSTNAME = os.environ.get("ELASTIC_HOSTNAME", "elasticsearch")
ELASTIC_PORT = os.environ.get("ELASTIC_PORT", 9200)
es = Elasticsearch([{"host": ELASTIC_HOSTNAME, "port": ELASTIC_PORT}])


def index(request):
    doc = {
        "author": "someone",
        "text": "Elasticsearch: cool. bonsai cool.",
        "timestamp": datetime.now(),
    }
    res = es.index(index="test-index", id=1, body=doc)
    print(res["result"])

    res = es.get(index="test-index", id=1)
    print(res["_source"])

    es.indices.refresh(index="test-index")

    res = es.search(index="test-index", query={"match_all": {}})
    print("Got %d Hits:" % res["hits"]["total"]["value"])
    for hit in res["hits"]["hits"]:
        print("%(timestamp)s %(author)s: %(text)s" % hit["_source"])

    return HttpResponse(
        f"Hello, world. You're at the test_elastic app index. Here's something from it {hit}"
    )
