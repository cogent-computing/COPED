# Generated by Django 3.2.7 on 2022-03-17 22:32

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0032_energysearchterm_active'),
    ]

    operations = [
        migrations.AddField(
            model_name='subject',
            name='energy_related',
            field=models.BooleanField(default=True, help_text='This subject is related to energy projects.'),
        ),
    ]