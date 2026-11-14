;ИНВЕРТИРОВАНИЕ ТАБЛИЦЫ МАСОК ДЛЯ 3D
            org  #8000
            ld   hl,#9000
            ld   b,#80
M1:
            ld   a,(hl)
            cpl  
            ld   c,a
            inc  l
            ld   a,(hl)
            cpl  
            and  c
            ld   (hl),a
            dec  l
            inc  h
            ld   a,(hl)
            cpl  
            ld   c,a
            inc  l
            ld   a,(hl)
            cpl  
            and  c
            ld   (hl),a
            inc  l
            dec  h
            djnz M1
            ret  
            org  #9000
            incbin "assets/awk2_D9000_2b.C"
