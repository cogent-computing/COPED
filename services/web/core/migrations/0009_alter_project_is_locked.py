# Generated by Django 3.2.7 on 2022-03-27 19:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0008_auto_20220327_1819'),
    ]

    operations = [
        migrations.AlterField(
            model_name='project',
            name='is_locked',
            field=models.BooleanField(default=False, help_text='Lock this project to prevent any automatic updates from overwriting your changes.'),
        ),
    ]
