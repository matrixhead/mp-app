# Generated by Django 3.0.5 on 2021-06-29 13:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('nivedhanamapp', '0005_auto_20210629_1313'),
    ]

    operations = [
        migrations.AlterField(
            model_name='nivedhanam',
            name='amount_sanctioned',
            field=models.FloatField(null=True),
        ),
    ]