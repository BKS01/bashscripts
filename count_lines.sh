#!/bin/bash

# Указать путь к системному файлу
file_path="/var/log/auth.log"

# Проверить, существует ли файл
if [ -f "$file_path" ]; then
    # Подсчитать количество строк в файле и сохранить результат в переменную
    line_count=$(wc -l < "$file_path")
    
    echo "Количество строк в файле \"$file_path\": $line_count"
else
    echo "Файл \"$file_path\" не существует."
fi
