# Generated by Django 3.2.7 on 2022-03-27 17:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0006_alter_person_external_links'),
    ]

    operations = [
        migrations.DeleteModel(
            name='GeoTag',
        ),
        migrations.AlterField(
            model_name='organisation',
            name='addresses',
            field=models.ManyToManyField(blank=True, to='core.Address'),
        ),
        migrations.AlterField(
            model_name='organisation',
            name='external_links',
            field=models.ManyToManyField(blank=True, to='core.ExternalLink'),
        ),
    ]
