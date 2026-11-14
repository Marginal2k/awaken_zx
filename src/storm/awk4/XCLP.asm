; XCLP -- restored from awk4/XCLP.C (20889 bytes, plain-text STORM export)
; (STORM source converted to sjasmplus by tools/convert_storm.py; see docs/STORM.md)
;ПPOЦEДУPЫ KЛИППИPOBAHИЯ
Clip    XOR A
        LD (L91+#2F),A
        LD (L91+#0A),A
        LD (L91+#2E),A
        PUSH HL
        LD A,B
        DEC A
        ADD A,L
        LD L,A
        LD A,H
        ADC A,#00
        LD H,A
        LD L,(HL)
        LD H,L9c
        LD E,(HL)
        INC L
        LD D,(HL)
        INC L
        LD (L91+#1B),DE
        LD E,(HL)
        INC L
        LD D,(HL)
        INC L
        LD (L91+#1D),DE
        LD A,(HL)
        LD (L91+#1F),A
Lc8b2   LD HL,(L91+#1B)
        LD (L91+#0B),HL
        LD HL,(L91+#1D)
        LD (L91+#0D),HL
        LD A,(L91+#1F)
        LD (L91+#0F),A
        POP HL
        LD A,(HL)
        INC HL
        PUSH HL
        PUSH BC
        LD L,A
        LD H,L9c
        LD E,(HL)
        INC L
        LD D,(HL)
        INC L
        LD (L91+#1B),DE
        LD E,(HL)
        INC L
        LD D,(HL)
        INC L
        LD (L91+#1D),DE
        LD A,(HL)
        LD (L91+#1F),A
        LD A,(L91+#0F)
        CPL
        AND #F0
        LD L,A
        LD A,(L91+#1F)
        AND #0F
        OR L
        LD L,A
        LD H,high(L95)
        LD E,(HL)
        INC H
        LD D,(HL)
        EX DE,HL
        LD DE,Lc8f9
        PUSH DE
        JP (HL)
Lc8f9   POP BC
        DJNZ Lc8b2
        POP HL
        LD A,(L91+#0A)
        CP #06
Lc902   RET
Lc903   CALL Lcd1e
Lc906   CALL Lcd5c
Lc909   CALL Lce87
        JP M,Lcda7
        CALL Lcdf9
Lc912   LD HL,L91+#2E
        BIT 0,(HL)
        JP NZ,Lce40
        SET 0,(HL)
        RET
Lc91d   CALL Lcd1e
Lc920   CALL Lcd3d
Lc923   CALL Lce73
        JP M,Lcdd0
        CALL Lcda7
Lc92c   LD HL,L91+#2E
        BIT 1,(HL)
        JP NZ,Lce35
        SET 1,(HL)
        RET
Lc937   CALL Lccff
Lc93a   CALL Lcd5c
Lc93d   CALL Lce5f
        JP M,Lcdf9
        CALL Lcd7e
Lc946   LD HL,L91+#2E
        BIT 2,(HL)
        JP NZ,Lce2a
        SET 2,(HL)
        RET
Lc951   CALL Lccff
Lc954   CALL Lcd3d
Lc957   CALL Lce4b
        JP M,Lcd7e
        CALL Lcdd0
Lc960   LD HL,L91+#2E
        BIT 3,(HL)
        JP NZ,Lce1f
        SET 3,(HL)
        RET
Lc96b   CALL Lcdf6
        JP Lceb1
Lc971   CALL Lcdf6
        JP Lcdcd
Lc977   CALL Lcd5c
Lc97a   CALL Lcd1e
        CALL Lce87
        JP P,Lce40
        CALL Lcdf9
        JP Lcda7
Lc989   CALL Lcd5c
Lc98c   CALL Lcd1e
        CALL Lce87
        JP M,Lc99b
        CALL Lce40
        JP Lc92c
Lc99b   CALL Lcdf9
        JP Lc920
Lc9a1   CALL Lcd5c
Lc9a4   CALL Lccff
        CALL Lce5f
        JP M,Lcec8
        CALL Lcdf9
        JP Lcd7e
Lc9b3   CALL Lce9b
        JP M,Lcec8
        RET
Lc9ba   CALL Lcd5c
Lc9bd   CALL Lccff
        CALL Lce5f
        JP M,Lcec8
        CALL Lcdf9
        JP Lc954
Lc9cc   CALL Lcdcd
        JP Lceb1
Lc9d2   CALL Lcdcd
        JP Lcdf6
Lc9d8   CALL Lcd3d
Lc9db   CALL Lcd1e
        CALL Lce73
        JP M,Lcec8
        CALL Lcdd0
        JP Lcda7
Lc9ea   CALL Lcd3d
Lc9ed   CALL Lcd1e
        CALL Lce73
        JP M,Lcec8
        CALL Lcdd0
        JP Lc906
Lc9fc   CALL Lce9b
        JP P,Lcec8
        RET
Lca03   CALL Lcd3d
Lca06   CALL Lccff
        CALL Lce4b
        JP P,Lce1f
        CALL Lcdd0
        JP Lcd7e
Lca15   CALL Lcd3d
Lca18   CALL Lccff
        CALL Lce4b
        JP M,Lca27
        CALL Lce1f
        JP Lc946
Lca27   CALL Lcdd0
        JP Lc93a
Lca2d   CALL Lcda4
        JP Lceb1
Lca33   CALL Lcd1e
Lca36   CALL Lcd5c
        CALL Lce87
        JP M,Lcec8
        CALL Lcda7
        JP Lcdf9
Lca45   CALL Lcd1e
Lca48   CALL Lcd3d
        CALL Lce73
        JP P,Lce35
        CALL Lcda7
        JP Lcdd0
Lca57   CALL Lcea6
        JP M,Lcec8
        RET
Lca5e   CALL Lcda4
        JP Lcd7b
Lca64   CALL Lcd1e
Lca67   CALL Lcd5c
        CALL Lce87
        JP M,Lcec8
        CALL Lcda7
        CALL Lccff
        JP Lc93d
Lca79   CALL Lcd1e
Lca7c   CALL Lcd3d
        CALL Lce73
        JP M,Lca8b
        CALL Lce35
        JP Lc960
Lca8b   CALL Lcda7
        CALL Lccff
        JP Lc957
Lca94   CALL Lcd1e
        CALL Lcd5c
        CALL Lce87
        JP M,Lcc13
        LD HL,L91+#2E
        BIT 0,(HL)
        SET 0,(HL)
        CALL NZ,Lce40
Lcaaa   CALL Lcda7
        JP Lceb1
Lcab0   CALL Lce9b
        JP P,Lcec8
        RET
Lcab7   CALL Lcd1e
        CALL Lcd5c
        CALL Lce87
        JP M,Lcad0
        LD HL,L91+#2E
        BIT 0,(HL)
        SET 0,(HL)
        CALL NZ,Lce40
        JP Lca48
Lcad0   CALL Lcdf9
        JP Lcdcd
Lcad6   LD HL,L91+#2E
        BIT 0,(HL)
        JP NZ,Lce40
        SET 0,(HL)
        RET
Lcae1   CALL Lcad6
        JP Lc92c
Lcae7   CALL Lcd1e
        CALL Lcd5c
        CALL Lce87
        JP M,Lc9a4
        CALL Lcad6
        CALL Lcda7
        JP Lcd7b
Lcafc   CALL Lcd1e
        CALL Lcd5c
        CALL Lce87
        JP M,Lc9bd
        LD HL,L91+#2E
        BIT 0,(HL)
        SET 0,(HL)
        CALL NZ,Lce40
        JP Lca7c
Lcb15   CALL Lcd1e
        CALL Lcd3d
        CALL Lce73
        JP M,Lcaaa
        LD HL,L91+#2E
        BIT 1,(HL)
        SET 1,(HL)
        CALL NZ,Lce35
Lcb2b   CALL Lcdd0
        JP Lceb1
Lcb31   CALL Lcd1e
        CALL Lcd3d
        CALL Lce73
        JP M,Lca36
        CALL Lcb46
        CALL Lcdd0
        JP Lcdf6
Lcb46   LD HL,L91+#2E
        BIT 1,(HL)
        JP NZ,Lce35
        SET 1,(HL)
        RET
Lcb51   CALL Lcea6
        JP P,Lcec8
        RET
Lcb58   CALL Lcd1e
        CALL Lcd3d
        CALL Lce73
        JP M,Lcb71
        LD HL,L91+#2E
        BIT 1,(HL)
        SET 1,(HL)
        CALL NZ,Lce35
        JP Lca06
Lcb71   CALL Lcda7
        JP Lcd7b
Lcb77   CALL Lcd1e
        CALL Lcd3d
        CALL Lce73
        JP M,Lca67
        LD HL,L91+#2E
        BIT 1,(HL)
        SET 1,(HL)
        CALL NZ,Lce35
        JP Lca18
Lcb90   CALL Lcb46
        JP Lc960
Lcb96   CALL Lcd7b
        JP Lceb1
Lcb9c   CALL Lccff
Lcb9f   CALL Lcd5c
        CALL Lce5f
        JP P,Lce2a
        CALL Lcd7e
        JP Lcdf9
Lcbae   CALL Lccff
Lcbb1   CALL Lcd3d
        CALL Lce4b
        JP M,Lcec8
        CALL Lcd7e
        JP Lcdd0
Lcbc0   CALL Lcd7b
        JP Lcda4
Lcbc6   CALL Lccff
Lcbc9   CALL Lcd5c
        CALL Lce5f
        JP M,Lcbd8
        CALL Lce2a
        JP Lc912
Lcbd8   CALL Lcd7e
        CALL Lcd1e
        JP Lc909
Lcbe1   CALL Lccff
Lcbe4   CALL Lcd3d
        CALL Lce4b
        JP M,Lcec8
        CALL Lcd7e
        CALL Lcd1e
        JP Lc923
Lcbf6   CALL Lcea6
        JP P,Lcec8
        RET
Lcbfd   CALL Lccff
        CALL Lcd5c
        CALL Lce5f
        JP M,Lcc94
        LD HL,L91+#2E
        BIT 2,(HL)
        SET 2,(HL)
        CALL NZ,Lce2a
Lcc13   CALL Lcdf9
        JP Lceb1
Lcc19   LD HL,L91+#2E
        BIT 2,(HL)
        JP NZ,Lce2a
        SET 2,(HL)
        RET
Lcc24   CALL Lccff
        CALL Lcd5c
        CALL Lce5f
        JP M,Lcbb1
        CALL Lcc19
        CALL Lcdf9
        JP Lcdcd
Lcc39   CALL Lccff
        CALL Lcd5c
        CALL Lce5f
        JP M,Lcc52
        LD HL,L91+#2E
        BIT 2,(HL)
        SET 2,(HL)
        CALL NZ,Lce2a
        JP Lc97a
Lcc52   CALL Lcd7e
        JP Lcda4
Lcc58   CALL Lcc19
        JP Lc912
Lcc5e   CALL Lccff
        CALL Lcd5c
        CALL Lce5f
        JP M,Lcbe4
        LD HL,L91+#2E
        BIT 2,(HL)
        SET 2,(HL)
        CALL NZ,Lce2a
        JP Lc98c
Lcc77   CALL Lcea6
        JP M,Lcec8
        RET
Lcc7e   CALL Lccff
        CALL Lcd3d
        CALL Lce4b
        JP M,Lcb2b
        LD HL,L91+#2E
        BIT 3,(HL)
        SET 3,(HL)
        CALL NZ,Lce1f
Lcc94   CALL Lcd7e
        JP Lceb1
Lcc9a   CALL Lccff
        CALL Lcd3d
        CALL Lce4b
        JP M,Lccb3
        LD HL,L91+#2E
        BIT 3,(HL)
        SET 3,(HL)
        CALL NZ,Lce1f
        JP Lcb9f
Lccb3   CALL Lcdd0
        JP Lcdf6
Lccb9   CALL Lce9b
        JP M,Lcec8
        RET
Lccc0   CALL Lccff
        CALL Lcd3d
        CALL Lce4b
        JP M,Lc9db
        CALL Lccee
        CALL Lcd7e
        JP Lcda4
Lccd5   CALL Lccff
        CALL Lcd3d
        CALL Lce4b
        JP M,Lc9ed
        LD HL,L91+#2E
        BIT 3,(HL)
        SET 3,(HL)
        CALL NZ,Lce1f
        JP Lcbc9
Lccee   LD HL,L91+#2E
        BIT 3,(HL)
        JP NZ,Lce1f
        SET 3,(HL)
        RET
Lccf9   CALL Lccee
        JP Lc946
Lccff   LD BC,(L91+#1B)
        LD HL,(L91+#0B)
        AND A
        SBC HL,BC
        EX DE,HL
        LD BC,#0000
        LD HL,(L91+#0D)
        AND A
        SBC HL,BC
        CALL Lcef2
        LD (L90+#DC),DE
        LD (L90+#DE),HL
        RET
Lcd1e   LD BC,(L91+#1B)
        LD HL,(L91+#0B)
        AND A
        SBC HL,BC
        EX DE,HL
        LD BC,#005F
        LD HL,(L91+#0D)
        AND A
        SBC HL,BC
        CALL Lcef2
        LD (L90+#EA),DE
        LD (L90+#EC),HL
        RET
Lcd3d
        LD BC,#0000
        LD HL,(L91+#0B)
        AND A
        SBC HL,BC
        EX DE,HL
        LD BC,(L91+#1D)
        LD HL,(L91+#0D)
        AND A
        SBC HL,BC
        CALL Lcef2
        LD (L90+#EE),DE
        LD (L90+#FA),HL
        RET
Lcd5c
        LD BC,#00FF
        LD HL,(L91+#0B)
        AND A
        SBC HL,BC
        EX DE,HL
        LD BC,(L91+#1D)
        LD HL,(L91+#0D)
        AND A
        SBC HL,BC
        CALL Lcef2
        LD (L90+#FC),DE
        LD (L90+#FE),HL
        RET
Lcd7b   CALL Lccff
Lcd7e   LD A,(L90+#DC)
        EX AF,AF
        LD A,(L90+#DD)
        LD HL,(L91+#1D)
        LD DE,(L91+#0D)
        AND A
        SBC HL,DE
        EX DE,HL
        LD HL,(L90+#DE)
        CALL Ld086
        LD DE,(L91+#0B)
        ADD HL,DE
        LD A,H
        AND A
        JR Z,O_1+2
        JP P,O_1
        LD A,(L91+#0A)
        LD L,A
        LD H,L9e
        XOR A
        LD (HL),A
        INC L
        LD (HL),A
        INC L
        LD A,L
        LD (L91+#0A),A
        RET
O_1
        LD L,#FF
        LD E,L
        LD A,(L91+#0A)
        LD L,A
        LD H,L9e
        LD (HL),E
        INC L
        LD (HL),0
        INC L
        LD A,L
        LD (L91+#0A),A
        RET
Lcda4   CALL Lcd1e
Lcda7   LD A,(L90+#EA)
        EX AF,AF
        LD A,(L90+#EB)
        LD HL,(L91+#1D)
        LD DE,(L91+#0D)
        AND A
        SBC HL,DE
        EX DE,HL
        LD HL,(L90+#EC)
        CALL Ld086
        LD DE,(L91+#0B)
        ADD HL,DE
        LD A,H
        AND A
        JR Z,O_2+2
        JP P,O_2
        LD A,(L91+#0A)
        LD L,A
        LD H,L9e
        LD (HL),0
        INC L
        LD (HL),#5F
        INC L
        LD A,L
        LD (L91+#0A),A
        RET
O_2
        LD L,#FF
        LD E,L
        LD A,(L91+#0A)
        LD L,A
        LD H,L9e
        LD (HL),E
        INC L
        LD (HL),#5F
        INC L
        LD A,L
        LD (L91+#0A),A
        RET
Lcdcd   CALL Lcd3d
Lcdd0   LD A,(L90+#EE)
        EX AF,AF
        LD A,(L90+#EF)
        LD HL,(L91+#1B)
        LD DE,(L91+#0B)
        AND A
        SBC HL,DE
        EX DE,HL
        LD HL,(L90+#FA)
        CALL Ld086
        LD DE,(L91+#0D)
        ADD HL,DE
        LD A,H
        AND A
        JP M,Io1
        LD A,L
        AND A
        JP P,Io2
        LD A,(L91+#0A)
        LD L,A
        LD H,L9e
        LD (HL),0
        INC L
        LD (HL),#5F
        INC L
        LD A,L
        LD (L91+#0A),A
        RET
Io1
        LD A,(L91+#0A)
        LD L,A
        LD H,L9e
        XOR A
        LD (HL),A
        INC L
        LD (HL),A
        INC L
        LD A,L
        LD (L91+#0A),A
        RET
Io2
        LD D,L
        LD A,(L91+#0A)
        LD L,A
        LD H,L9e
        LD (HL),0
        INC L
        LD (HL),D
        INC L
        LD A,L
        LD (L91+#0A),A
        RET
Lcdf6   CALL Lcd5c
Lcdf9   LD A,(L90+#FC)
        EX AF,AF
        LD A,(L90+#FD)
        LD HL,(L91+#1B)
        LD DE,(L91+#0B)
        AND A
        SBC HL,DE
        EX DE,HL
        LD HL,(L90+#FE)
        CALL Ld086
        LD DE,(L91+#0D)
        ADD HL,DE
        LD A,H
        AND A
        JP M,Io4
        LD A,L
        AND A
        JP P,Io3
        LD A,(L91+#0A)
        LD L,A
        LD H,L9e
        LD (HL),#FF
        INC L
        LD (HL),#5F
        INC L
        LD A,L
        LD (L91+#0A),A
        RET
Io4
        LD A,(L91+#0A)
        LD L,A
        LD H,L9e
        LD (HL),#FF
        INC L
        LD (HL),0
        INC L
        LD A,L
        LD (L91+#0A),A
        RET
Io3
        LD D,L
        LD A,(L91+#0A)
        LD L,A
        LD H,L9e
        LD (HL),#FF
        INC L
        LD (HL),D
        INC L
        LD A,L
        LD (L91+#0A),A
        RET
Lce1f   LD A,(L91+#2F)
        AND A
        RET NZ
        LD DE,#0000
        JP Lceb9
Lce2a   LD A,(L91+#2F)
        AND A
        RET NZ
        LD DE,#00FF
        JP Lceb9
Lce35   LD A,(L91+#2F)
        AND A
        RET NZ
        LD DE,#5F00
        JP Lceb9
Lce40   LD A,(L91+#2F)
        AND A
        RET NZ
        LD DE,#5FFF
        JP Lceb9
Lce4b   AND A
        LD HL,(L90+#DC)
        LD BC,(L90+#EE)
        SBC HL,BC
        LD HL,(L90+#DE)
        LD BC,(L90+#FA)
        SBC HL,BC
        RET
Lce5f   AND A
        LD HL,(L90+#DC)
        LD BC,(L90+#FC)
        SBC HL,BC
        LD HL,(L90+#DE)
        LD BC,(L90+#FE)
        SBC HL,BC
        RET
Lce73   AND A
        LD HL,(L90+#EA)
        LD BC,(L90+#EE)
        SBC HL,BC
        LD HL,(L90+#EC)
        LD BC,(L90+#FA)
        SBC HL,BC
        RET
Lce87   AND A
        LD HL,(L90+#EA)
        LD BC,(L90+#FC)
        SBC HL,BC
        LD HL,(L90+#EC)
        LD BC,(L90+#FE)
        SBC HL,BC
        RET
Lce9b   LD HL,(L91+#1B)
        LD DE,(L91+#0B)
        AND A
        SBC HL,DE
        RET
Lcea6   LD HL,(L91+#1D)
        LD DE,(L91+#0D)
        AND A
        SBC HL,DE
        RET
Lceb1   LD A,(L91+#1B)
        LD E,A
        LD A,(L91+#1D)
        LD D,A
Lceb9   LD A,(L91+#0A)
        LD L,A
        LD H,L9e
        LD (HL),E
        INC L
        LD (HL),D
        INC L
        LD A,L
        LD (L91+#0A),A
        RET
Lcec8   POP AF
        POP BC
        POP HL
        LD C,B
        DEC C
        LD B,#00
        ADD HL,BC
        SCF
        RET




;KBAДPAT. HLDE=HL^2
Lcef0   LD D,H
        LD E,L
;УMHOЖEHИE HLDE=HL*DE
Mull
Lcef2   LD A,H
        XOR D
        PUSH AF
        BIT 7,D
        JR Z,$+9
        LD A,E
        CPL
        LD E,A
        LD A,D
        CPL
        LD D,A
        INC DE
        BIT 7,H
        JR Z,$+9
        LD A,L
        CPL
        LD L,A
        LD A,H
        CPL
        LD H,A
        INC HL
        EX DE,HL
        LD A,D
        AND A
        JP Z,Lcfda
        LD A,H
        AND A
        JP Z,Lcfdf
        LD BC,#0000
        LD IX,#0000
        ADD HL,HL
        ADD HL,HL
        JP C,Lcf2a
        ADD HL,HL
        JP C,Lcf34
        ADD HL,HL
        JP C,Lcf3e
        ADD HL,HL
        JP C,Lcf48
        ADD HL,HL
        JP C,Lcf52
        ADD HL,HL
        JP C,Lcf5c
        ADD HL,HL
        JP Lcf66
Lcf2a   ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
Lcf34   ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
Lcf3e   ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
Lcf48   ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
Lcf52   ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
Lcf5c   ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
Lcf66   ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
        ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
        ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
        ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
        ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
        ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
        ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
        ADD IX,DE
        ADC HL,BC
        ADD IX,IX
        ADC HL,HL
        JR NC,$+6
        ADD IX,DE
        ADC HL,BC
        LD D,IXH
        LD E,IXL
Lcfbe   POP AF
        RET P
        LD B,H
        LD C,L
        LD HL,#0000
        SBC HL,DE
        EX DE,HL
        LD HL,#0000
        SBC HL,BC
        RET
Lcfda   LD A,H
        AND A
        JR Z,Ld030
        EX DE,HL
Lcfdf   LD A,L
        LD L,H
        LD C,H
        ADD A,A
        JR C,Lcffd
        ADD A,A
        JR C,Ld003
        ADD A,A
        JR C,Ld009
        ADD A,A
        JR C,Ld00f
        ADD A,A
        JR C,Ld015
        ADD A,A
        JR C,Ld01b
        ADD A,A
        JR C,Ld021
        ADD A,A
        JR C,Ld027
        JP Ld029
Lcffd   ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
Ld003   ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
Ld009   ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
Ld00f   ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
Ld015   ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
Ld01b   ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
Ld021   ADD HL,DE
        ADC A,C
        ADD HL,HL
        ADC A,A
        JR NC,$+4
Ld027   ADD HL,DE
        ADC A,C
Ld029
        EX DE,HL
        LD L,A
        LD H,#00
        JP Lcfbe
Ld030   RR E
        JR C,Ld053
        RR E
        JR C,Ld059
        RR E
        JR C,Ld05f
        RR E
        JR C,Ld065
        RR E
        JR C,Ld06b
        RR E
        JR C,Ld071
        RR E
        JR C,Ld077
        RR E
        JR C,Ld07d
        JP Ld081
Ld053   ADD A,L
        RRA
        RR E
        JR NC,$+3
Ld059   ADD A,L
        RRA
        RR E
        JR NC,$+3
Ld05f   ADD A,L
        RRA
        RR E
        JR NC,$+3
Ld065   ADD A,L
        RRA
        RR E
        JR NC,$+3
Ld06b   ADD A,L
        RRA
        RR E
        JR NC,$+3
Ld071   ADD A,L
        RRA
        RR E
        JR NC,$+3
Ld077   ADD A,L
        RRA
        RR E
        JR NC,$+3
Ld07d   ADD A,L
        RRA
        RR E
Ld081   LD D,A
        LD L,H
        JP Lcfbe
;ДEЛEHИE HL=HL/DE
Ld086   LD IXL,#00
        JP P,Ld098
        EX DE,HL
        LD B,H
        LD C,L
        LD HL,#0000
        AND A
        SBC HL,BC
        EX DE,HL
        INC IXL
Ld098   BIT 7,H
        JR Z,Ld0aa
        EX AF,AF
        CPL
        EX AF,AF
        CPL
        LD B,H
        LD C,L
        LD HL,#0000
        SCF
        SBC HL,BC
        INC IXL
Ld0aa   RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        EX AF,AF
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        ADC HL,HL
        SBC HL,DE
        JR NC,$+3
        ADD HL,DE
        RLA
        DEC IXL
        JR NZ,$+6
        LD L,A
        EX AF,AF
        LD H,A
        RET
        CPL
        LD L,A
        EX AF,AF
        CPL
        LD H,A
        RET





;LINES CLIPPING
CLIPLIN
        LD A,#01
        LD (L91+#2F),A
        LD A,(L91+#0F)
        CP #F0
        JR NZ,Ld16e
        LD B,A
        LD A,(L91+#1F)
        LD (L91+#0F),A
        LD A,B
        LD (L91+#1F),A
        LD HL,(L91+#0B)
        LD DE,(L91+#1B)
        LD (L91+#1B),HL
        LD (L91+#0B),DE
        LD HL,(L91+#0D)
        LD DE,(L91+#1D)
        LD (L91+#1D),HL
        LD (L91+#0D),DE
Ld16e   XOR A
        LD (L91+#0A),A
        LD A,(L91+#0F)
        CPL
        AND #F0
        LD L,A
        LD A,(L91+#1F)
        AND #0F
        OR L
        LD L,A
        LD H,high(L95)
        LD E,(HL)
        INC H
        LD D,(HL)
        EX DE,HL
        LD DE,Ld18d
        PUSH DE
        PUSH DE
        PUSH DE
        JP (HL)
Ld18d   LD A,(L91+#0A)
        POP DE
        POP DE
        CP #04
        RET
