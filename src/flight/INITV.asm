; ИНИЦИАЛИЗАЦИЯ ПЕРЕМЕННЫХ
INITV1:
            ld   hl,#C9F1
            ld   (#5CC2),hl

            ld   a,r
            ld   l,a
            ld   (SDO),hl
            and  3
            inc  a
            ld   b,a
            push bc
            call RND
            pop  bc
            djnz $-5
            ld   (SDW),hl
            call RND
            ld   (SDK1),hl
            call RND
            ld   (SDK2),hl
            call RND
            ld   (SDK3),hl
            call RND
            ld   (SDL1),hl
            call RND
            ld   (SDL2),hl
            call RND
            ld   (SDL3),hl
            call RND
            ld   (SDL4),hl


            ld   a,1
            ld   (PODSWET+1),a
            ld   a,46
            ld   (PEREGREV+1),a

            ret

;GEN TABLE Y.B=2^(X/256)-1 ,X=(0;1)
GEN2X:      ld   ix,TB2X
            ld   hl,0
.GN2X       ld   a,h                ;ROUNDING
            bit  7,l
            jr   z,$+3
            inc  a
            ld   (ix),a
            xor  a
            exx
            ld   l,a
            ld   h,a
            ld   e,a
            ld   bc,#00B2           ;(2^1/256)*#10000
            exx
            ld   bc,#1801
.GN2X1      rr   c
            rr   h
            rr   l
            exx
            jr   nc,.GN2X2
            add  hl,bc
            adc  a,1
.GN2X2      rra
            rr   h
            rr   l
            exx
            djnz .GN2X1
            ld   a,c
            rra
            exx
            ld   h,l
            ld   l,a
            inc  ixl
            jr   nz,.GN2X
            ret
;GEN TABLE Y.W=LOG2(X) ,X=(1,255)
GENLOG2:    ld   hl,TBLOG2
            xor  a
            ld   e,a
            ld   d,a
            ld   (hl),a
            inc  h
            ld   (hl),#F0
            dec  h
            inc  l
.GNLG1      ld   (hl),d
            inc  h
            ld   (hl),a
            dec  h
            ex   af,af'
            push hl
            push de
            ld   de,#74E9
            ld   c,l
            srl  c
            rr   d
            xor  a
            ld   hl,#B8AA
            exx
            ld   h,a
            ld   l,a
            ld   b,#10
.GNLG2      exx
            add  hl,hl
            adc  a,a
            sbc  hl,de
            sbc  a,c
            jr   nc,.GNLG3
            add  hl,de
            adc  a,c
.GNLG3      exx
            ccf
            rl   l
            rl   h
            djnz .GNLG2
            pop  de
            ex   af,af'
            add  hl,de
            adc  a,b
            ex   de,hl
            pop  hl
            inc  l
            jr   nz,.GNLG1
            ret
GENTBXY:
; ГЕНЕРИМ ТАБЛИЦУ ПЕРЕВОД КООРДИНАТ В
; АДРЕС С #8000
            ld   hl,TBXY
            ld   de,#8000
            ld   bc,32
.MT1
            ld   (hl),d
            inc  h
            ld   (hl),e
            dec  h
            ex   de,hl
            add  hl,bc
            ex   de,hl
            inc  l
            jr   nz,.MT1
            inc  h
            inc  h
            ld   a,#80
            ex   af,af'
            xor  a
.MT3
            ld   b,8
.MT2
            ld   (hl),a
            ex   af,af'
            inc  h
            ld   (hl),a
            rrca
            dec  h
            ex   af,af'
            inc  l
            djnz .MT2
            inc  a
            cp   32
            jr   c,.MT3
            ret
