# Generated by Django 3.2.7 on 2022-04-10 23:45

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0020_personsubscription'),
    ]

    operations = [
        migrations.CreateModel(
            name='OrganisationSubscription',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('added', models.DateTimeField(auto_now_add=True)),
                ('organisation', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='core.organisation')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'coped_organisation_subscription',
                'unique_together': {('organisation', 'user')},
            },
        ),
    ]
