# Generated by Django 3.0.5 on 2021-08-13 12:29

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('nivedhanamapp', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='category',
            name='category_name',
            field=models.CharField(max_length=100, unique=True),
        ),
    ]
