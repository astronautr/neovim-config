# Установка
Для работы автодополнения, линтеров и прочего, необходимо установить языковые серверы

Lua
```sh
brew install lua-language-server
```

TypeScript / JavaScript
```sh
npm i -g typescript typescript-language-server
```

Go
```sh
go install golang.org/x/tools/gopls@latest
```

# To Do
- [x] Диагностика ошибок в файлах и проекте, прыжки по выводу диагностики
- [] Форматирование через eslint, prettier, go fmt (?)
- [] Фильтрация по расширениям файлов при поиске
- [] Статус бар (режим, текущая строка, etc.)
- [] Список открытых буферов (bufferline)
- [] Ввод команд на русской раскладке
