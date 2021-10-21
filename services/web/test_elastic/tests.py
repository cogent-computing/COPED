import os
from datetime import datetime
from elasticsearch import Elasticsearch
from django.test import TestCase

# Create your tests here.


class ElasticTestCase(TestCase):
    @classmethod
    def setUpClass(cls):
        super(ElasticTestCase, cls).setUpClass()

        ELASTIC_HOSTNAME = os.environ.get("ELASTIC_HOSTNAME", "elasticsearch")
        ELASTIC_PORT = os.environ.get("ELASTIC_PORT", 9200)
        ELASTIC_USER = os.environ.get("ELASTIC_USER", "elastic")
        ELASTIC_PASS = os.environ.get("ELASTICSEARCH_PASSWORD", "password")

        cls.es = Elasticsearch(
            [{"host": ELASTIC_HOSTNAME, "port": ELASTIC_PORT}],
            http_auth=(ELASTIC_USER, ELASTIC_PASS),
        )

    def setUp(self):

        self.test_index = "test-index"
        self.test_doc = {
            "author": "someone",
            "text": "Elasticsearch: cool. bonsai cool.",
            "timestamp": str(datetime.now()),
        }
        self.test_doc_id = 1
        self.es.delete(index=self.test_index, id=self.test_doc_id, ignore=[400, 404])

    def test_elastic_can_add_and_retrieve_docs(self):
        self.assertTrue(self.es.ping(), "Elasticsearch should be pingable")

        res = self.es.index(
            index=self.test_index, id=self.test_doc_id, body=self.test_doc
        )
        self.assertEqual(res["result"], "created", "Document should be created")

        self.es.indices.refresh(index=self.test_index)
        res = self.es.get(index=self.test_index, id=self.test_doc_id)
        self.assertTrue(res["found"], "Document should be found")
        self.assertEqual(res["_source"], self.test_doc, "Same document should be found")

        self.es.indices.refresh(index=self.test_index)
        res = self.es.search(index=self.test_index, query={"match_all": {}})
        first_match = res["hits"]["hits"][0]["_source"]
        self.assertEqual(first_match, self.test_doc, "Document should be searchable")

    def tearDown(self):
        self.es.delete(index=self.test_index, id=self.test_doc_id, ignore=[400, 404])
