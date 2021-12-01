# Generated by Django 3.2.7 on 2021-11-30 21:31

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0007_auto_20211130_2005'),
    ]

    operations = [
        migrations.AlterField(
            model_name='projectkeyword',
            name='score',
            field=models.FloatField(blank=True, help_text='Strength of match for the keyword with this project.', null=True),
        ),
    ]