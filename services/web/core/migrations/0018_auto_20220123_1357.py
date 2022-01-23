# Generated by Django 3.2.7 on 2022-01-23 13:57

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0017_alter_metabasesession_user'),
    ]

    operations = [
        migrations.AlterField(
            model_name='externallink',
            name='description',
            field=models.CharField(max_length=128),
        ),
        migrations.AlterField(
            model_name='externallink',
            name='link',
            field=models.URLField(help_text="Link URL including 'http://' or 'https://'."),
        ),
        migrations.AlterField(
            model_name='linkedproject',
            name='relation',
            field=models.CharField(default='Linked Project', max_length=64),
        ),
        migrations.AlterField(
            model_name='projectorganisation',
            name='role',
            field=models.CharField(default='Lead Organisation', max_length=64),
        ),
        migrations.AlterField(
            model_name='projectperson',
            name='role',
            field=models.CharField(default='Lead Person', max_length=64),
        ),
    ]
