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

ESLint
```sh
npm i -g vscode-langservers-extracted
```

Go
```sh
go install golang.org/x/tools/gopls@latest
```

# To Do
- [x] Диагностика ошибок в файлах и проекте, прыжки по выводу диагностики
- [ ] Форматирование через
    - [x] eslint
    - [ ] prettier
    - [ ] go fmt (?)
- [ ] Фильтрация по расширениям файлов при поиске
- [x] Статус бар (режим, текущая строка, etc.)
- [x] Список открытых буферов (bufferline)
- [ ] Ввод команд на русской раскладке
