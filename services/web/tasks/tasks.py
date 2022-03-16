from celery import shared_task


@shared_task
def test(param):
    return f"The test task executed with argument '{param}'."
