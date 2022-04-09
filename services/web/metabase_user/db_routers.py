class MetabaseUserRouter:
    def db_for_read(self, model, **hints):
        if model._meta.app_label == "metabase_user":
            return "metabase"
        return None

    def db_for_write(self, model, **hints):
        if model._meta.app_label == "metabase_user":
            return "metabase"
        return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        if db == "metabase":
            return False  # no DB changes allowed
        return None
