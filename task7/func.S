/*

    Подпрограммы и соглашения о связях

*/
.include "macros.S" # подключение файла с макроопределениями

.data # секция данных, распределение памяти


Symbols:
        .asciz  "91A23B456C789" # массив символьных кодов
#                                 цифр и "не цифр"

.bss    # секция общей памяти (для результата)

.lcomm  Numbers, 40             # массив 4-х байтовых значений цифр

        .text # секция команд процесора

.type   Read_Sym, @function     # функция циклической обработки массива

Read_Sym:

/*
        Читает <Параметр1> символов из массива <Параметр2>
        и передает их на обработку функции Trans_Sym.
        Результат размещается в массив Numbers
*/
#       Стандартный пролог фунции

        pushl %ebp       # сохранить в стеке значение, бывшее в вызывающей
        movl  %esp, %ebp # обеспечить адресный доступ к параметрам и 
                         # локальным переменнным в стеке путем базовой 
                         # адресации через ebp
        subl  $4, %esp   # завести 4-х байтовую локальную переменную
        movl  $0xdadadada,%eax
        movl  %eax,-4(%ebp)
        mov   $0xfefefefe,%eax
#       Тело функции

        subl %ecx, %ecx   # инициализация счетчика цикла 
NextSym:
        movl 12(%ebp), %edx  # адрес второго параметра-массива в edx

#       вызов функции Trans_Sym



        subl %ebx, %ebx             # подготовка ebx для записи символа
        movb (%edx,%ecx,1), %bl     # символ в ebx

#       Начинаем вызов Trans_Sym

        pusha   # сохранить регистры текущей функции Read_Sym

        pushl %ebx                # Параметр функции Trans_Sym (код 
                                  # символа из массива) в стек
        call Trans_Sym

        addl    $4,%esp      # очистить стек от параметров Trans_Sym

        movl    %eax, Numbers(,%ecx,4) # записать результат Trans-Sym

        popa   # восстановть регистры Read_Sym

        incl %ecx            # наращиваем счетчик цикла
        cmpl 8(%ebp), %ecx   # счетчик равен первому параметру?
        jne NextSym          # ДА, повторяем
                             # НЕТ - выходим из цикла

#       Стандартный эпилог функции

        movl %ebp, %esp # восстановить указатель стека
        popl %ebp       # восстановить ebp
        ret             # возврат в вызывающую

# конец Read_Sym

/*
    Функция преобразования кода символа в числовое значение
    <Пареметр1> преобразуется в число и возвращается в eax */

.type   Trans_Sym, @function

Trans_Sym:

#       Стандартный пролог фунции

        pushl %ebp       # сохранить в стеке значение, бывшее в вызывающей
        movl  %esp, %ebp # обеспечить адресный доступ к параметрам и 
                         # локальным переменнным в стеке путем базовой 
                         # адресации через ebp

#       тело функции

        movl 8(%ebp), %eax  # параметр в eax
        subl $0x30, %eax    # получение числового значения

#       Стандартный эпилог функции

        movl %ebp, %esp # восстановить указатель стека
        popl %ebp       # восстановить ebp
        ret             # возврат в вызывающую


.global _start # точка входа - глобальная метка

_start:

                nop

                pusha   # сохранение регистров главной программы

                pushl $Symbols  # Параметр-2 - адрес массива в стек
                pushl $8        # Параметр-1 в стек

                call Read_Sym   # вызов функции

                addl $8,%esp    # очистить стек от параметров Read_Sym
                popa         # восстановить регистры главной програмы

                Finish # конец работы, возврат в ОС (макро из файла my-macro)
                .end   # последняя строка исходного текста

