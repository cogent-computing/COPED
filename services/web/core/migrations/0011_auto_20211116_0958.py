# Generated by Django 3.2.7 on 2021-11-16 09:58

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0010_auto_20211115_2217'),
    ]

    operations = [
        migrations.AddField(
            model_name='project',
            name='end',
            field=models.DateTimeField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='project',
            name='start',
            field=models.DateTimeField(blank=True, null=True),
        ),
    ]
