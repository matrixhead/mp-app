# Generated by Django 3.0.5 on 2021-06-17 08:33

from django.db import migrations, models
import django.db.models.deletion
import djongo.storage


class Migration(migrations.Migration):

    dependencies = [
        ('nivedhanamapp', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='nivedhanam',
            name='scan',
        ),
        migrations.CreateModel(
            name='Scan',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('scan', models.ImageField(storage=djongo.storage.GridFSStorage(base_url='scan_collection/', collection='scan_collection'), upload_to='scan_collection')),
                ('SI_no', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='nivedhanamapp.Nivedhanam')),
            ],
        ),
    ]
