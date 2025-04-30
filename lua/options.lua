--[[ Отступы и форматирование ]] --
-- Настройки табуляции
vim.o.expandtab = true -- Заменяет табы на пробелы
vim.o.tabstop = 4 -- Ширина таба
vim.o.softtabstop = 4 -- Количество пробелов при нажатии Tab
vim.o.shiftwidth = 4 -- Количество пробелов для автоотступа

-- Умные отступы
vim.o.smartindent = true -- Умные отступы (например, после {)
vim.o.autoindent = true -- Копирует отступ предыдущей строки
vim.o.preserveindent = true -- Сохраняет структуру отступов
vim.o.copyindent = true -- Копирует структуру отступов при автоотступе
vim.o.breakindent = true -- Сохраняет отступы при переносе строк

--[[ Интерфейс и отображение ]] --
-- Нумерация строк
vim.o.number = true -- Показывает номера строк
vim.o.relativenumber = true -- Относительная нумерация строк
vim.o.signcolumn = "yes" -- Столбец для знаков (git, диагностика)
vim.opt.cursorline = true -- Подсветка текущей строки

-- Цвета и отображение
vim.o.showmode = false -- Отключает показ режима в командной строке
--[[ vim.opt.list = true    -- Показывает спецсимволы
vim.opt.listchars = { nbsp = '␣' } ]]

--[[ Поиск и замена ]] --
vim.o.ignorecase = true -- Игнорирует регистр при поиске
vim.o.smartcase = true -- Учитывает регистр если есть символы в верхнем регистре
vim.o.incsearch = true -- Интерактивный поиск
vim.o.inccommand = "split" -- Интерактивный предпросмотр замен

--[[ Файлы и буферы ]] --
-- Файловые операции
vim.o.swapfile = false -- Отключает создание swap файлов
vim.o.backup = false -- Отключает создание резервных копий
vim.o.undofile = true -- Сохраняет историю изменений
vim.o.autowrite = true -- Автосохранение при переключении буферов
vim.o.fileencoding = "utf-8" -- Кодировка файлов
vim.o.confirm = true -- Подтверждение при закрытии несохраненных файлов

-- Буферы и окна
vim.o.splitbelow = true -- Новые окна открываются снизу
vim.o.splitright = true -- Новые окна открываются справа

--[[ Дополнительные функции ]] --
-- Системные настройки
vim.o.mouse = "a" -- Включает поддержку мыши
vim.o.history = 1000 -- Размер истории команд
vim.opt.clipboard:append("unnamed") -- Использование системного буфера обмена

-- Автодополнение
vim.o.completeopt = "menuone,noselect" -- Настройки автодополнения
vim.o.pumheight = 15                   -- Максимальная высота меню автодополнения

-- Форматирование
vim.o.formatoptions = "jcroqlnt" -- Опции автоформатирования

--[[ Маппинги клавиш ]] --
-- Лидер
vim.g.mapleader = " "
-- Очистка поиска и терминал
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- Диагностика
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- Ресайз окна
vim.keymap.set({ "n", "v" }, "<M-K>", ":m .-2<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<M-J>", ":m .+1<CR>", { noremap = true, silent = true })
---
vim.keymap.set("n", "<M-l>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-h>", ":vertical resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-k>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-j>", ":resize +2<CR>", { noremap = true, silent = true })

---
vim.keymap.set({ "n", "v" }, "<leader>w", ":bd<CR>", { noremap = true, silent = true })

local function saveAndExecute()
    vim.lsp.buf.format({})
    vim.cmd("wa")
end


vim.keymap.set({ "n", "v", "i" }, "<C-s>", saveAndExecute, { noremap = true, silent = true })

vim.api.nvim_create_user_command("Vb", function(opts)
    vim.cmd("vert sb " .. opts.args)
end, { nargs = 1 })
