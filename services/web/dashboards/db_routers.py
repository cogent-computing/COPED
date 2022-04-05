class DashboardRouter:
    def db_for_read(self, model, **hints):
        if model._meta.app_label == "dashboards":
            return "metabase"
        return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        if db == "metabase":
            return False  # no DB changes allowed
        return None
