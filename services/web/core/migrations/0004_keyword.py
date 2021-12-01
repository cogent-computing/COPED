# Generated by Django 3.2.7 on 2021-11-30 15:34

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0003_passwchange'),
    ]

    operations = [
        migrations.CreateModel(
            name='Keyword',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('text', models.CharField(max_length=128)),
            ],
            options={
                'verbose_name_plural': 'Keywords and Phrases',
                'db_table': 'coped_keyword',
            },
        ),
    ]