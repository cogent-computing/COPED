# Generated by Django 3.2.7 on 2021-11-11 12:17

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0003_externallink_description'),
    ]

    operations = [
        migrations.AddField(
            model_name='fund',
            name='external_links',
            field=models.ManyToManyField(to='core.ExternalLink'),
        ),
        migrations.AddField(
            model_name='organisation',
            name='external_links',
            field=models.ManyToManyField(to='core.ExternalLink'),
        ),
        migrations.AddField(
            model_name='project',
            name='external_links',
            field=models.ManyToManyField(to='core.ExternalLink'),
        ),
    ]