from pinax.messages.models import Thread as PinaxThread


class Thread(PinaxThread):
    """Proxy model that lets us add new methods to threads."""

    class Meta:
        proxy = True

    @classmethod
    def read(cls, user):
        # return list of already read threads
        return cls.inbox(user).exclude(userthread__unread=True)
