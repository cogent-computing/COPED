# Generated by Django 3.2.7 on 2022-03-27 16:03

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0005_remove_address_owner'),
    ]

    operations = [
        migrations.AlterField(
            model_name='person',
            name='external_links',
            field=models.ManyToManyField(blank=True, to='core.ExternalLink'),
        ),
    ]
