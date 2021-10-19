# Generated by Django 3.2.7 on 2021-10-18 21:00

import django.core.validators
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='CouchDBName',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(help_text='Provide the name of a CouchDB database.', max_length=128)),
                ('authority', models.IntegerField(default=1000, help_text='How authoritative is this source? 1 is most, 1000 least.', validators=[django.core.validators.MinValueValidator(1), django.core.validators.MaxValueValidator(1000)])),
            ],
            options={
                'db_table': 'coped_couchdb_name',
            },
        ),
        migrations.CreateModel(
            name='ResourceType',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('description', models.TextField(help_text='What type of resource is this?')),
                ('is_outcome', models.BooleanField(default=False, help_text='Is this a type of project outcome?')),
            ],
            options={
                'db_table': 'coped_resource_type',
            },
        ),
        migrations.CreateModel(
            name='Resource',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('document_id', models.UUIDField(unique=True)),
                ('couchdb_name', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='coped_resources.couchdbname')),
                ('resource_type', models.ForeignKey(editable=False, on_delete=django.db.models.deletion.PROTECT, to='coped_resources.resourcetype')),
            ],
            options={
                'db_table': 'coped_resource',
            },
        ),
        migrations.CreateModel(
            name='RelationType',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('description', models.CharField(help_text="What is the nature of the relation between the resource types, e.g. 'Project lead'?", max_length=128)),
                ('is_weighted', models.BooleanField(default=False, help_text='Is this relation type quantifiable?')),
                ('resource_type_1', models.ForeignKey(help_text="What is the type of the source resource, e.g. 'person'?", on_delete=django.db.models.deletion.CASCADE, related_name='source', to='coped_resources.resourcetype', verbose_name='Source resource type')),
                ('resource_type_2', models.ForeignKey(help_text="What is the type of the target resource, e.g. 'project'?", on_delete=django.db.models.deletion.CASCADE, related_name='target', to='coped_resources.resourcetype', verbose_name='Target resource type')),
            ],
            options={
                'db_table': 'coped_relation_type',
            },
        ),
        migrations.CreateModel(
            name='Relation',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('relation_weight', models.FloatField(help_text='When the relation is quantifiable, what is the strength of the connection?', null=True)),
                ('relation_type', models.ForeignKey(help_text='How is the source related to the target?', on_delete=django.db.models.deletion.PROTECT, to='coped_resources.relationtype')),
                ('resource_1', models.ForeignKey(help_text='Source of a two-way relation between CoPED resources', on_delete=django.db.models.deletion.CASCADE, related_name='source', to='coped_resources.resource')),
                ('resource_2', models.ForeignKey(help_text='Target of a two-way relation between CoPED resources', on_delete=django.db.models.deletion.CASCADE, related_name='target', to='coped_resources.resource')),
            ],
            options={
                'db_table': 'coped_relation',
            },
        ),
        migrations.AddIndex(
            model_name='resource',
            index=models.Index(fields=['document_id'], name='document_id_idx'),
        ),
        migrations.AddIndex(
            model_name='resource',
            index=models.Index(fields=['couchdb_name'], name='couchdb_name_idx'),
        ),
        migrations.AddIndex(
            model_name='resource',
            index=models.Index(fields=['resource_type'], name='resource_type_idx'),
        ),
        migrations.AlterUniqueTogether(
            name='relationtype',
            unique_together={('resource_type_1', 'resource_type_2')},
        ),
        migrations.AddIndex(
            model_name='relation',
            index=models.Index(fields=['resource_1', 'resource_2'], name='forward_relation_idx'),
        ),
        migrations.AddIndex(
            model_name='relation',
            index=models.Index(fields=['resource_2', 'resource_1'], name='backward_relation_idx'),
        ),
        migrations.AddIndex(
            model_name='relation',
            index=models.Index(fields=['relation_type'], name='relation_type_idx'),
        ),
        migrations.AlterUniqueTogether(
            name='relation',
            unique_together={('resource_1', 'resource_2', 'relation_type')},
        ),
    ]