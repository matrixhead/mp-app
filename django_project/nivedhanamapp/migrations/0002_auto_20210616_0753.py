# Generated by Django 3.0.5 on 2021-06-16 07:53

from django.db import migrations, models
import djongo.storage


class Migration(migrations.Migration):

    dependencies = [
        ('nivedhanamapp', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='nivedhanam',
            name='scan',
            field=models.ImageField(storage=djongo.storage.GridFSStorage(collection='scan_collection'), upload_to='scan_collection'),
        ),
    ]