.macro Exit ret_val
	movl $1, %eax 		# номер сист. вызова exit
	movl \ret_val, %ebx 	# код выхода
	int $0x80 		# выполнить системный вызов
.endm

.macro Getchar buf_addr
	movl $3, %eax		# номер сист. вызова read
	movl $0, %ebx		# параметр 1: дескриптор стандартного ввода
	movl \buf_addr, %ecx	# параметр 2: адрес буфера (он же - фактический 
	     			# параметр макровызова)
	movl $1, %edx		# параметр 3: количество байтов для чтения
	int $0x80		# выполнить системный вызов
.endm

.macro Puts string
.data
    str\@: 	.ascii "\string\n"  # формирование фактической строки для вывода
	
    strlen\@ = 	. - str\@           # получение значения длины строки

.text
	movl $4, %eax		# номер сист. вызова write
	movl $1, %ebx		# параметр 1: дескриптор стандартного вывода	
	movl $str\@, %ecx	# параметр 2: адрес памяти с выводимыми символами
	movl $strlen\@, %edx 	# параметр 3: количество байтов для вывода
	int $0x80		# выполнить системный вызов
.endm
