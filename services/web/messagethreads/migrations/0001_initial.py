# Generated by Django 3.2.7 on 2022-03-22 13:47

from django.db import migrations


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('pinax_messages', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Thread',
            fields=[
            ],
            options={
                'proxy': True,
                'indexes': [],
                'constraints': [],
            },
            bases=('pinax_messages.thread',),
        ),
    ]
