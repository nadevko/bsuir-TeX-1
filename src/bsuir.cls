\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bsuir}[2025/12/28 BSUIR LaTeX class]

% Загрузка expl3 и l3keys2e для обработки опций
\RequirePackage{expl3}
\RequirePackage{l3keys2e}

% Обработка опций класса
\ExplSyntaxOn

% Определение сообщений об ошибках
\msg_new:nnn { bsuir } { unknown-option }
{
  Unknown~option~'#1'~for~class~bsuir.~Only~'std=01-2024'~is~supported.
}

\msg_new:nnn { bsuir } { invalid-std }
{
  Invalid~standard~version~'#1'.~Only~'01-2024'~is~supported.
}

\str_new:N \l_bsuir_std_str
\str_set:Nn \l_bsuir_std_str { 01-2024 }

\keys_define:nn { bsuir }
{
  std .choice:,
  std / 01-2024 .code:n = { \str_set:Nn \l_bsuir_std_str { 01-2024 } },
  std .initial:n = { 01-2024 },
  std .default:n = { 01-2024 },
  unknown .code:n = {
    \msg_error:nnn { bsuir } { unknown-option } { \l_keys_key_str }
  }
}

% Обработка опций через l3keys2e
\ProcessKeysOptions { bsuir }

% Проверка версии стандарта
\str_if_eq:NNTF \l_bsuir_std_str { 01-2024 }
{
  % Версия стандарта корректна
}
{
  \msg_error:nnx { bsuir } { invalid-std } { \l_bsuir_std_str }
}

\ExplSyntaxOff

% Загрузка базового класса scrreprt
\LoadClass{scrreprt}

% Загрузка модулей в правильном порядке
\RequirePackage{bsuir-base}      % Раздел 1: Общие требования
\RequirePackage{bsuir-lang}      % Языки
\RequirePackage{bsuir-headings}   % Раздел 2: Заголовки и рубрикация
\RequirePackage{bsuir-text}       % Раздел 3: Текст и перечисления
\RequirePackage{bsuir-math}       % Раздел 4: Математические формулы
\RequirePackage{bsuir-figures}    % Раздел 5: Иллюстрации
\RequirePackage{bsuir-tables}     % Раздел 6: Таблицы
\RequirePackage{bsuir-listings}   % Раздел 10: Листинги
\RequirePackage{bsuir-appendix}  % Раздел 7: Приложения
\RequirePackage{bsuir-bibliography} % Раздел 8: Библиография
\RequirePackage{bsuir-notes}      % Раздел 9: Сноски и примечания
\RequirePackage{bsuir-pdf}        % Внешние PDF
