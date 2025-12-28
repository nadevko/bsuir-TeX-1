\NeedsTeXFormat{LaTeX2e}[2023-06-01]
\ProvidesClass{bsuir}[2025/12/28 v1.0.0 BSUIR Diploma Class]

% --- Обработка опций (Modern LaTeX3 Key-Value Interface) ---
\RequirePackage{expl3}
\RequirePackage{l3keys2e}
\ExplSyntaxOn

% Сообщения об ошибках (L3)
\msg_new:nnn { bsuir } { unknown-option }
  {
    Unknown~option~'#1'~for~class~bsuir.\\
    Check~documentation~for~available~options.
  }

% Внутренние переменные для опций
\tl_new:N \l_bsuir_std_tl

% Определение ключей класса
\keys_define:nn { bsuir }
  {
    std .choice:,
    std / 01-2024 .code:n = { \tl_set:Nn \l_bsuir_std_tl { 01-2024 } },
    std .initial:n = { 01-2024 },
    std .default:n = { 01-2024 },
    unknown .code:n = {
      \msg_error:nnn { bsuir } { unknown-option } { \CurrentOption }
    }
  }

% Обработка опций класса
\ProcessKeysOptions { bsuir }

\ExplSyntaxOff

% --- Базовый класс (KOMA-Script) ---
% chapterprefix=false -> "1. Введение", а не "Глава 1. Введение"
% numbers=noenddot  -> "1.1", а не "1.1." (хотя ГОСТ требует точку, STP БГУИР часто просит без)
% Используем правильные имена опций KOMA-Script
\LoadClass[
  fontsize=14pt,
  paper=A4,
  DIV=calc,
  BCOR=10mm,  % Переплет для корректного расчета полей
  numbers=noenddot, 
  listof=totoc,
  chapterprefix=false,
  headings=small,
  version=last
]{scrreprt}

% --- Загрузка модулей ---
% Порядок важен: сначала база, потом шрифты/языки, потом структура
\RequirePackage{bsuir-base}
\RequirePackage{bsuir-headings}
\RequirePackage{bsuir-text}
\RequirePackage{bsuir-math}
\RequirePackage{bsuir-figures}
\RequirePackage{bsuir-tables}
\RequirePackage{bsuir-listings}
\RequirePackage{bsuir-appendix}
\RequirePackage{bsuir-bibliography}
\RequirePackage{bsuir-notes}
\RequirePackage{bsuir-pdf}

\endinput
