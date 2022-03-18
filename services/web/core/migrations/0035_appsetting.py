# Generated by Django 3.2.7 on 2022-03-17 23:34

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0034_alter_subject_energy_related'),
    ]

    operations = [
        migrations.CreateModel(
            name='AppSetting',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=128)),
                ('value', models.CharField(max_length=256)),
            ],
            options={
                'verbose_name_plural': 'Application Settings',
                'db_table': 'coped_app_setting',
            },
        ),
    ]