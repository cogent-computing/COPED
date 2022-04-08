import logging
import time
import jwt
from django.shortcuts import get_object_or_404
from .models import Setting as MetabaseSetting
from core.models import AppSetting


def dashboard_embed_url(dashboard_id, bordered=False, titled=True, theme=None):

    logging.debug("dashboard_id %s", dashboard_id)

    bordered = "true" if bordered else "false"
    titled = "true" if titled else "false"

    setting = MetabaseSetting.objects.filter(key="embedding-secret-key").first()
    embedding_secret_key = getattr(setting, "value", "")
    logging.info("embedding_secret_key %s", embedding_secret_key)

    setting = AppSetting.objects.filter(slug="METABASE_EMBEDDING_HOST").first()
    metabase_embedding_host = getattr(setting, "value", "coped.coventry.ac.uk:81")
    logging.info("metabase_site_url %s", metabase_embedding_host)

    payload = {
        "resource": {"dashboard": dashboard_id},
        "params": {},
        "exp": round(time.time()) + (60 * 10),  # 10 minute expiration
    }
    token = jwt.encode(payload, embedding_secret_key, algorithm="HS256")

    embed_url = f"{metabase_embedding_host}/embed/dashboard/{token}#bordered={bordered}&titled={titled}&theme={theme}"

    logging.info("embed_url %s", embed_url)

    return embed_url
