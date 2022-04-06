# Generated by Django 3.2.7 on 2022-04-06 00:24

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Dashboard',
            fields=[
                ('id', models.IntegerField(primary_key=True, serialize=False)),
                ('created_at', models.DateTimeField()),
                ('updated_at', models.DateTimeField()),
                ('name', models.CharField(max_length=254)),
                ('description', models.TextField(null=True)),
                ('creator_id', models.IntegerField()),
                ('parameters', models.TextField(null=True)),
                ('public_uuid', models.CharField(max_length=36, null=True)),
                ('made_public_by_id', models.IntegerField(null=True)),
                ('enable_embedding', models.BooleanField(default=False)),
                ('embedding_params', models.TextField(null=True)),
                ('archived', models.BooleanField(default=False)),
                ('collection_id', models.IntegerField(null=True)),
            ],
            options={
                'db_table': 'report_dashboard',
                'managed': False,
            },
        ),
        migrations.CreateModel(
            name='Setting',
            fields=[
                ('key', models.CharField(max_length=254, primary_key=True, serialize=False)),
                ('value', models.TextField(blank=True)),
            ],
            options={
                'db_table': 'setting',
                'managed': False,
            },
        ),
    ]
