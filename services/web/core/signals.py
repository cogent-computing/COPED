"""
Application signal handlers.
"""


def user_activation_handler(sender, **kwargs):
    """
    Add a user profile into Metabase when a user confirms and activates their account.

    This allows user access to the functionality of Metabase in a more seamless way.
    """
    print("A user was activated!")
    print("Sender", sender)
    print("kwargs", kwargs)
