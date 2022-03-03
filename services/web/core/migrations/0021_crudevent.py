# Generated by Django 3.2.7 on 2022-02-17 11:16

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        # ("easyaudit", "0016_auto_20220217_1116"),
        ("core", "0020_remove_projectfund_currency"),
    ]

    operations = [
        migrations.CreateModel(
            name="CRUDEvent",
            fields=[
                (
                    "crudevent_ptr",
                    models.OneToOneField(
                        auto_created=True,
                        on_delete=django.db.models.deletion.CASCADE,
                        parent_link=True,
                        primary_key=True,
                        serialize=False,
                        to="easyaudit.crudevent",
                    ),
                ),
                ("object_json", models.JSONField()),
            ],
            options={
                "db_table": "coped_crudevent",
            },
            bases=("easyaudit.crudevent",),
        ),
    ]
