#!/bin/bash

# Запросить строку с помощью команды read
echo "Введите строку:"
read string

# Использовать команду grep для поиска всех букв, игнорируя регистр
# Затем использовать команду wc для подсчета количества строк
letter_count=$(echo "$string" | grep -o '[a-zA-Z]' | wc -l)

echo "Количество букв в строке: $letter_count"