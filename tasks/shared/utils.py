import os
import logging as coped_logging
from datetime import datetime

LOGLEVEL = os.environ.get("LOGLEVEL", "INFO").upper()
coped_logging.basicConfig(
    level=LOGLEVEL,
    format="%(asctime)s COPED %(levelname)-8s %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
