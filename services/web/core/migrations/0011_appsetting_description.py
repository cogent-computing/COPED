# Generated by Django 3.2.7 on 2022-04-03 11:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0010_auto_20220327_2117'),
    ]

    operations = [
        migrations.AddField(
            model_name='appsetting',
            name='description',
            field=models.TextField(blank=True),
        ),
    ]
