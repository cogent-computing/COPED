import logging
import time
import jwt
from django.shortcuts import get_object_or_404
from .models import Setting


def dashboard_embed_url(dashboard_id, bordered=False, titled=True, theme=None):
    bordered = "true" if bordered else "false"
    titled = "true" if titled else "false"

    logging.debug("dashboard_id", dashboard_id)
    embedding_secret_key = (
        get_object_or_404(Setting, key="embedding-secret-key").value or ""
    )
    logging.debug("embedding_secret_key", embedding_secret_key)
    metabase_site_url = get_object_or_404(Setting, key="site-url").value or ""
    logging.debug("metabase_site_url", metabase_site_url)
    payload = {
        "resource": {"dashboard": dashboard_id},
        "params": {},
        "exp": round(time.time()) + (60 * 10),  # 10 minute expiration
    }
    token = jwt.encode(payload, embedding_secret_key, algorithm="HS256")
    embed_url = f"{metabase_site_url}/embed/dashboard/{token}#bordered={bordered}&titled={titled}&theme={theme}"
    logging.debug("embed_url", embed_url)
    return embed_url
