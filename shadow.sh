#!/bin/bash

# Указываем исходный файл
source_file="/etc/shadow"

# Создаем копию файла
cp "$source_file" "./shadow_copy"

# Перемещаем копию в другое место
destination_path="/path/to/new/location"
mv "./shadow_copy" "$destination_path"

# Переименовываем файл
new_filename="new_shadow"
mv "$destination_path/shadow_copy" "$destination_path/$new_filename"

# Ищем последовательность букв "user*" в файле
search_pattern="user*"
grep "$search_pattern" "$destination_path/$new_filename"
# Запускаем скрипт с root правами!!!!
