# Generated by Django 3.2.7 on 2022-03-22 13:47

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('easyaudit', '0001_initial'),
        ('crudevents', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='copedcrudevent',
            name='easyaudit',
            field=models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='easyaudit.crudevent'),
        ),
    ]
