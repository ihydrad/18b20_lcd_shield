
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _adc_data=R3
	.DEF _adc_data_msb=R4
	.DEF _but_state=R6
	.DEF __lcd_x=R5
	.DEF __lcd_y=R8
	.DEF __lcd_maxx=R7

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_gr:
	.DB  0xC,0x12,0x12,0xC,0x0,0x0,0x0
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x54,0x65,0x6D,0x70,0x20,0x3D,0x20,0x25
	.DB  0x33,0x64,0x0,0x45,0x72,0x72,0x6F,0x72
	.DB  0x20,0x72,0x65,0x61,0x64,0x0,0x53,0x74
	.DB  0x61,0x72,0x74,0x65,0x64,0x2E,0x2E,0x2E
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0B
	.DW  _0x27
	.DW  _0x0*2+11

	.DW  0x0B
	.DW  _0x2A
	.DW  _0x0*2+22

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <alcd.h>
;#include <stdio.h>
;#include <1wire.h>
;
;#define  SBI(PORT,BIT)       PORT|=(1<<BIT)
;#define  CBI(PORT,BIT)       PORT&=~(1<<BIT)
;#define  CHK_FLAG(I)         (flag & (1 << I))
;#define  CHK(BYTE,I)         (BYTE & (1 << I))
;#define  LIGHT_LCD           PORTB.2
;#define  DHT11               1
;#define  DIV                 10
;#define START_ADC            SBI(ADCSRA, 6)
;
;#define UP_PRESS_STATE       0
;#define DOWN_PRESS_STATE     1
;#define RIGHT_PRESS_STATE    2
;#define LEFT_PRESS_STATE     3
;#define SELECT_PRESS_STATE   4
;
;flash unsigned char
;gr[]=  { 0xC,0x12,0x12,0xC,0x00,0x00,0x00 };
;
;unsigned int
;adc_data;
;
;unsigned char
;but_state;
;/*********************************************************
; >INTERRUPT ROUT          10ms
;*********************************************************/
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0022 {

	.CSEG
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
; 0000 0023  TCNT2=0x64;
	LDI  R30,LOW(100)
	STS  178,R30
; 0000 0024 
; 0000 0025  //if(!PINB.2)timer_light++;
; 0000 0026  //if(timer_light > 500) LIGHT_LCD = 0;
; 0000 0027 }
	RJMP _0x2F
; .FEND
;/*********************************************************
; >INTERRUPT ROUT          10us
;*********************************************************/
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 002C {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
; 0000 002D  TCNT0=0x60;
	LDI  R30,LOW(96)
	OUT  0x26,R30
; 0000 002E }
_0x2F:
	LD   R30,Y+
	RETI
; .FEND
;
;/*********************************************************
; >INTERRUPT ROUT          ADC
;*********************************************************/
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0034 {
_adc_isr:
; .FSTART _adc_isr
	ST   -Y,R0
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0035  adc_data = ADCW;
	__GETWRMN 3,4,0,120
; 0000 0036 
; 0000 0037  if(adc_data > 100 && adc_data < 200)  SBI(but_state, UP_PRESS_STATE);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R3
	CPC  R31,R4
	BRSH _0x4
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R3,R30
	CPC  R4,R31
	BRLO _0x5
_0x4:
	RJMP _0x3
_0x5:
	LDI  R30,LOW(1)
	OR   R6,R30
; 0000 0038  if(adc_data > 200 && adc_data < 300) SBI(but_state, DOWN_PRESS_STATE);
_0x3:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R30,R3
	CPC  R31,R4
	BRSH _0x7
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R3,R30
	CPC  R4,R31
	BRLO _0x8
_0x7:
	RJMP _0x6
_0x8:
	LDI  R30,LOW(2)
	OR   R6,R30
; 0000 0039  if(!adc_data || adc_data < 100)       SBI(but_state, RIGHT_PRESS_STATE);
_0x6:
	MOV  R0,R3
	OR   R0,R4
	BREQ _0xA
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R3,R30
	CPC  R4,R31
	BRSH _0x9
_0xA:
	LDI  R30,LOW(4)
	OR   R6,R30
; 0000 003A  if(adc_data > 300 && adc_data < 500) SBI(but_state, LEFT_PRESS_STATE);
_0x9:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CP   R30,R3
	CPC  R31,R4
	BRSH _0xD
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CP   R3,R30
	CPC  R4,R31
	BRLO _0xE
_0xD:
	RJMP _0xC
_0xE:
	LDI  R30,LOW(8)
	OR   R6,R30
; 0000 003B  if(adc_data > 500 && adc_data < 700) SBI(but_state, SELECT_PRESS_STATE);
_0xC:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CP   R30,R3
	CPC  R31,R4
	BRSH _0x10
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CP   R3,R30
	CPC  R4,R31
	BRLO _0x11
_0x10:
	RJMP _0xF
_0x11:
	LDI  R30,LOW(16)
	OR   R6,R30
; 0000 003C }
_0xF:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void init_dev()
; 0000 003F {
_init_dev:
; .FSTART _init_dev
; 0000 0040 #pragma optsize-
; 0000 0041 CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0042 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0043 #ifdef _OPTIMIZE_SIZE_
; 0000 0044 #pragma optsize+
; 0000 0045 #endif
; 0000 0046 
; 0000 0047 // Input/Output Ports initialization
; 0000 0048 // Port B initialization
; 0000 0049 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 004A DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(255)
	OUT  0x4,R30
; 0000 004B // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 004C PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 004D 
; 0000 004E // Port C initialization
; 0000 004F // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0050 DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x7,R30
; 0000 0051 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0052 PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (1<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(50)
	OUT  0x8,R30
; 0000 0053 
; 0000 0054 // Port D initialization
; 0000 0055 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0056 DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(255)
	OUT  0xA,R30
; 0000 0057 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0058 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0059 
; 0000 005A // Timer/Counter 0 initialization
; 0000 005B // Clock source: System Clock
; 0000 005C // Clock value: 16000,000 kHz
; 0000 005D // Mode: Normal top=0xFF
; 0000 005E // OC0A output: Disconnected
; 0000 005F // OC0B output: Disconnected
; 0000 0060 // Timer Period: 0,01 ms
; 0000 0061 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x24,R30
; 0000 0062 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 0063 TCNT0=0x60;
	LDI  R30,LOW(96)
	OUT  0x26,R30
; 0000 0064 OCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0065 OCR0B=0x00;
	OUT  0x28,R30
; 0000 0066 
; 0000 0067 // Timer/Counter 1 initialization
; 0000 0068 // Clock source: System Clock
; 0000 0069 // Clock value: Timer1 Stopped
; 0000 006A // Mode: Normal top=0xFFFF
; 0000 006B // OC1A output: Disconnected
; 0000 006C // OC1B output: Disconnected
; 0000 006D // Noise Canceler: Off
; 0000 006E // Input Capture on Falling Edge
; 0000 006F // Timer1 Overflow Interrupt: Off
; 0000 0070 // Input Capture Interrupt: Off
; 0000 0071 // Compare A Match Interrupt: Off
; 0000 0072 // Compare B Match Interrupt: Off
; 0000 0073 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 0074 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	STS  129,R30
; 0000 0075 TCNT1H=0x00;
	STS  133,R30
; 0000 0076 TCNT1L=0x00;
	STS  132,R30
; 0000 0077 ICR1H=0x00;
	STS  135,R30
; 0000 0078 ICR1L=0x00;
	STS  134,R30
; 0000 0079 OCR1AH=0x00;
	STS  137,R30
; 0000 007A OCR1AL=0x00;
	STS  136,R30
; 0000 007B OCR1BH=0x00;
	STS  139,R30
; 0000 007C OCR1BL=0x00;
	STS  138,R30
; 0000 007D 
; 0000 007E // Timer/Counter 2 initialization
; 0000 007F // Clock source: System Clock
; 0000 0080 // Clock value: 15,625 kHz
; 0000 0081 // Mode: Normal top=0xFF
; 0000 0082 // OC2A output: Disconnected
; 0000 0083 // OC2B output: Disconnected
; 0000 0084 // Timer Period: 9,984 ms
; 0000 0085 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 0086 TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 0087 TCCR2B=(0<<WGM22) | (1<<CS22) | (1<<CS21) | (1<<CS20);
	LDI  R30,LOW(7)
	STS  177,R30
; 0000 0088 TCNT2=0x64;
	LDI  R30,LOW(100)
	STS  178,R30
; 0000 0089 OCR2A=0x00;
	LDI  R30,LOW(0)
	STS  179,R30
; 0000 008A OCR2B=0x00;
	STS  180,R30
; 0000 008B 
; 0000 008C // Timer/Counter 0 Interrupt(s) initialization
; 0000 008D TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 008E 
; 0000 008F // Timer/Counter 1 Interrupt(s) initialization
; 0000 0090 TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 0091 
; 0000 0092 // Timer/Counter 2 Interrupt(s) initialization
; 0000 0093 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (1<<TOIE2);
	LDI  R30,LOW(1)
	STS  112,R30
; 0000 0094 
; 0000 0095 // External Interrupt(s) initialization
; 0000 0096 // INT0: Off
; 0000 0097 // INT1: Off
; 0000 0098 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0099 // Interrupt on any change on pins PCINT8-14: Off
; 0000 009A // Interrupt on any change on pins PCINT16-23: Off
; 0000 009B EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	STS  105,R30
; 0000 009C EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 009D PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 009E 
; 0000 009F // USART initialization
; 0000 00A0 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00A1 // USART Receiver: Off
; 0000 00A2 // USART Transmitter: On
; 0000 00A3 // USART0 Mode: Asynchronous
; 0000 00A4 // USART Baud Rate: 9600
; 0000 00A5 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	STS  192,R30
; 0000 00A6 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(8)
	STS  193,R30
; 0000 00A7 UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 00A8 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 00A9 UBRR0L=0x67;
	LDI  R30,LOW(103)
	STS  196,R30
; 0000 00AA 
; 0000 00AB // Analog Comparator initialization
; 0000 00AC // Analog Comparator: Off
; 0000 00AD // The Analog Comparator's positive input is
; 0000 00AE // connected to the AIN0 pin
; 0000 00AF // The Analog Comparator's negative input is
; 0000 00B0 // connected to the AIN1 pin
; 0000 00B1 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 00B2 // Digital input buffer on AIN0: On
; 0000 00B3 // Digital input buffer on AIN1: On
; 0000 00B4 DIDR1=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	STS  127,R30
; 0000 00B5 
; 0000 00B6 // ADC initialization
; 0000 00B7 // ADC Clock frequency: 125,000 kHz
; 0000 00B8 // ADC Voltage Reference: AVCC pin
; 0000 00B9 // ADC Auto Trigger Source: ADC Stopped
; 0000 00BA // Digital input buffers on ADC0: Off, ADC1: On, ADC2: On, ADC3: On
; 0000 00BB // ADC4: On, ADC5: On
; 0000 00BC #define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
; 0000 00BD DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (1<<ADC0D);
	LDI  R30,LOW(1)
	STS  126,R30
; 0000 00BE ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 00BF ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(143)
	STS  122,R30
; 0000 00C0 ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 00C1 
; 0000 00C2 // SPI initialization
; 0000 00C3 // SPI Type: Master
; 0000 00C4 // SPI Clock Rate: 2*4000,000 kHz
; 0000 00C5 // SPI Clock Phase: Cycle Start
; 0000 00C6 // SPI Clock Polarity: Low
; 0000 00C7 // SPI Data Order: MSB First
; 0000 00C8 SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(80)
	OUT  0x2C,R30
; 0000 00C9 SPSR=(1<<SPI2X);
	LDI  R30,LOW(1)
	OUT  0x2D,R30
; 0000 00CA 
; 0000 00CB // TWI initialization
; 0000 00CC // TWI disabled
; 0000 00CD TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	LDI  R30,LOW(0)
	STS  188,R30
; 0000 00CE 
; 0000 00CF // Bit-Banged I2C Bus initialization
; 0000 00D0 // I2C Port: PORTC
; 0000 00D1 // I2C SDA bit: 4
; 0000 00D2 // I2C SCL bit: 5
; 0000 00D3 // Bit Rate: 100 kHz
; 0000 00D4 // Note: I2C settings are specified in the
; 0000 00D5 // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 00D6 
; 0000 00D7 // Alphanumeric LCD initialization
; 0000 00D8 // Connections are specified in the
; 0000 00D9 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00DA // RS - PORTB Bit 0
; 0000 00DB // RD - PORTB Bit 7
; 0000 00DC // EN - PORTB Bit 1
; 0000 00DD // D4 - PORTD Bit 4
; 0000 00DE // D5 - PORTD Bit 5
; 0000 00DF // D6 - PORTD Bit 6
; 0000 00E0 // D7 - PORTD Bit 7
; 0000 00E1 // Characters/line: 16
; 0000 00E2 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00E3 
; 0000 00E4 // Global enable interrupts
; 0000 00E5 #asm("sei")
	sei
; 0000 00E6 }
	RET
; .FEND
;
;void define_char(char flash *pc,char char_code){
; 0000 00E8 void define_char(char flash *pc,char char_code){
_define_char:
; .FSTART _define_char
; 0000 00E9 
; 0000 00EA char i,a;
; 0000 00EB  #asm("cli")
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	cli
; 0000 00EC a=(char_code<<3)|0x40;
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
; 0000 00ED 
; 0000 00EE   for(i=0;i<8;i++){
	LDI  R17,LOW(0)
_0x13:
	CPI  R17,8
	BRSH _0x14
; 0000 00EF 
; 0000 00F0      lcd_write_byte(a++, *pc++);
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R26,Z
	CALL _lcd_write_byte
; 0000 00F1     }
	SUBI R17,-1
	RJMP _0x13
_0x14:
; 0000 00F2    #asm("sei")
	sei
; 0000 00F3 }
	JMP  _0x2080002
; .FEND
;
;signed char DS18B20_read()
; 0000 00F6 {
_DS18B20_read:
; .FSTART _DS18B20_read
; 0000 00F7  unsigned char a, b, i, j, crc = 0, data[9];
; 0000 00F8  signed char tmp;
; 0000 00F9 
; 0000 00FA //Старт конвертации
; 0000 00FB     #asm("cli")
	SBIW R28,9
	CALL __SAVELOCR6
;	a -> R17
;	b -> R16
;	i -> R19
;	j -> R18
;	crc -> R21
;	data -> Y+6
;	tmp -> R20
	LDI  R21,0
	cli
; 0000 00FC     a = w1_init();
	CALL _w1_init
	MOV  R17,R30
; 0000 00FD     w1_write(0xCC);   // skip rom
	LDI  R26,LOW(204)
	CALL _w1_write
; 0000 00FE     w1_write(0x44);   // start conv
	LDI  R26,LOW(68)
	CALL _w1_write
; 0000 00FF 
; 0000 0100     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0101 
; 0000 0102 //Чтение датчика
; 0000 0103     w1_init();
	CALL _w1_init
; 0000 0104     w1_write(0xCC);  // skip rom
	LDI  R26,LOW(204)
	CALL _w1_write
; 0000 0105     w1_write(0xBE);  // read scratch pad
	LDI  R26,LOW(190)
	CALL _w1_write
; 0000 0106 
; 0000 0107     for(i = 0; i < 9; i++)
	LDI  R19,LOW(0)
_0x16:
	CPI  R19,9
	BRSH _0x17
; 0000 0108       data[i] = w1_read();
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL _w1_read
	POP  R26
	POP  R27
	ST   X,R30
	SUBI R19,-1
	RJMP _0x16
_0x17:
; 0000 0109 w1_init();
	CALL _w1_init
; 0000 010A     #asm("sei")
	sei
; 0000 010B 
; 0000 010C //Контроль четности
; 0000 010D     for(i = 0; i < 9; i++)
	LDI  R19,LOW(0)
_0x19:
	CPI  R19,9
	BRSH _0x1A
; 0000 010E     {
; 0000 010F         a = data[i];
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R17,X
; 0000 0110 
; 0000 0111         for(j = 0; j < 8; j++)
	LDI  R18,LOW(0)
_0x1C:
	CPI  R18,8
	BRSH _0x1D
; 0000 0112         {
; 0000 0113             b = a;
	MOV  R16,R17
; 0000 0114             a ^= crc;
	EOR  R17,R21
; 0000 0115             if(a & 1) crc = ((crc ^ 0x18) >> 1) | 0x80;
	SBRS R17,0
	RJMP _0x1E
	LDI  R30,LOW(24)
	EOR  R30,R21
	LDI  R31,0
	ASR  R31
	ROR  R30
	ORI  R30,0x80
	MOV  R21,R30
; 0000 0116             else crc >>= 1;
	RJMP _0x1F
_0x1E:
	LSR  R21
; 0000 0117             a = b >> 1;
_0x1F:
	MOV  R30,R16
	LSR  R30
	MOV  R17,R30
; 0000 0118         }
	SUBI R18,-1
	RJMP _0x1C
_0x1D:
; 0000 0119     }
	SUBI R19,-1
	RJMP _0x19
_0x1A:
; 0000 011A 
; 0000 011B //Вычисление температуры
; 0000 011C     if(!crc)
	CPI  R21,0
	BRNE _0x20
; 0000 011D     {
; 0000 011E         if( (data[1] >> 4) & 0x0F )
	LDD  R30,Y+7
	LDI  R31,0
	CALL __ASRW4
	ANDI R30,LOW(0xF)
	BREQ _0x21
; 0000 011F         {
; 0000 0120             tmp = ~(data[0] >> 4);
	LDD  R30,Y+6
	SWAP R30
	ANDI R30,0xF
	COM  R30
	MOV  R20,R30
; 0000 0121             tmp += ~(data[1] << 4);
	LDD  R30,Y+7
	SWAP R30
	ANDI R30,0xF0
	COM  R30
	ADD  R20,R30
; 0000 0122             tmp += 2;
	SUBI R20,-LOW(2)
; 0000 0123 
; 0000 0124             if((data[0] >> 3) & 0x01 ) tmp++;  // округление до целых
	LDD  R30,Y+6
	LDI  R31,0
	CALL __ASRW3
	ANDI R30,LOW(0x1)
	BREQ _0x22
	SUBI R20,-1
; 0000 0125 
; 0000 0126             tmp = -tmp;
_0x22:
	NEG  R20
; 0000 0127         }
; 0000 0128         else
	RJMP _0x23
_0x21:
; 0000 0129         {
; 0000 012A             tmp = data[0] >> 4;
	LDD  R30,Y+6
	SWAP R30
	ANDI R30,0xF
	MOV  R20,R30
; 0000 012B             tmp += data[1] << 4;
	LDD  R30,Y+7
	SWAP R30
	ANDI R30,0xF0
	ADD  R20,R30
; 0000 012C         }
_0x23:
; 0000 012D 
; 0000 012E         tmp--;
	SUBI R20,1
; 0000 012F 
; 0000 0130         return tmp;
	MOV  R30,R20
	RJMP _0x2080005
; 0000 0131     }
; 0000 0132     else
_0x20:
; 0000 0133     {
; 0000 0134         return 255;
	LDI  R30,LOW(255)
; 0000 0135     }
; 0000 0136 }
_0x2080005:
	CALL __LOADLOCR6
	ADIW R28,15
	RET
; .FEND
;
;void print_data(signed char var)
; 0000 0139 {
_print_data:
; .FSTART _print_data
; 0000 013A   unsigned char array[16];
; 0000 013B 
; 0000 013C   lcd_clear();
	ST   -Y,R26
	SBIW R28,16
;	var -> Y+16
;	array -> Y+0
	RCALL _lcd_clear
; 0000 013D 
; 0000 013E   if(var != -1)
	LDD  R26,Y+16
	CPI  R26,LOW(0xFF)
	BREQ _0x25
; 0000 013F   {
; 0000 0140     sprintf(array, "Temp = %3d", var);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+20
	CALL __CBD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0141     lcd_gotoxy(3, 0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0142     lcd_puts(array);
	MOVW R26,R28
	RCALL _lcd_puts
; 0000 0143     lcd_putchar(1);
	LDI  R26,LOW(1)
	RCALL _lcd_putchar
; 0000 0144   }
; 0000 0145   else
	RJMP _0x26
_0x25:
; 0000 0146   {
; 0000 0147     lcd_gotoxy(3, 0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0148     lcd_puts("Error read");
	__POINTW2MN _0x27,0
	RCALL _lcd_puts
; 0000 0149   }
_0x26:
; 0000 014A }
	ADIW R28,17
	RET
; .FEND

	.DSEG
_0x27:
	.BYTE 0xB
;
;void main(void)
; 0000 014D {

	.CSEG
_main:
; .FSTART _main
; 0000 014E  init_dev();
	RCALL _init_dev
; 0000 014F  LIGHT_LCD = 1;
	SBI  0x5,2
; 0000 0150  w1_init();
	CALL _w1_init
; 0000 0151  define_char(gr, 1);
	LDI  R30,LOW(_gr*2)
	LDI  R31,HIGH(_gr*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _define_char
; 0000 0152  lcd_puts("Started...");
	__POINTW2MN _0x2A,0
	RCALL _lcd_puts
; 0000 0153 
; 0000 0154 while (1)
_0x2B:
; 0000 0155       {
; 0000 0156         print_data(DS18B20_read());
	RCALL _DS18B20_read
	MOV  R26,R30
	RCALL _print_data
; 0000 0157         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0158       }
	RJMP _0x2B
; 0000 0159 }
_0x2E:
	RJMP _0x2E
; .FEND

	.DSEG
_0x2A:
	.BYTE 0xB
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0xB
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0xB,R30
	__DELAY_USB 27
	SBI  0x5,1
	__DELAY_USB 27
	CBI  0x5,1
	__DELAY_USB 27
	RJMP _0x2080003
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RJMP _0x2080003
; .FEND
_lcd_write_byte:
; .FSTART _lcd_write_byte
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL __lcd_write_data
	SBI  0x5,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x5,0
	RJMP _0x2080004
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R8,Y+0
_0x2080004:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x0
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x0
	LDI  R30,LOW(0)
	MOV  R8,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R8
	MOV  R26,R8
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2080003
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x5,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x5,0
	RJMP _0x2080003
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0xA
	ORI  R30,LOW(0xF0)
	OUT  0xA,R30
	SBI  0x4,1
	SBI  0x4,0
	SBI  0x4,7
	CBI  0x5,1
	CBI  0x5,0
	CBI  0x5,7
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1
	CALL SUBOPT_0x1
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080003:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020016
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020018
	__CPWRN 16,17,2
	BRLO _0x2020019
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020018:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020019:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x202001A
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x202001A:
	RJMP _0x202001B
_0x2020016:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x202001B:
_0x2080002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x202001C:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x202001E
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2020022
	CPI  R18,37
	BRNE _0x2020023
	LDI  R17,LOW(1)
	RJMP _0x2020024
_0x2020023:
	CALL SUBOPT_0x2
_0x2020024:
	RJMP _0x2020021
_0x2020022:
	CPI  R30,LOW(0x1)
	BRNE _0x2020025
	CPI  R18,37
	BRNE _0x2020026
	CALL SUBOPT_0x2
	RJMP _0x20200D2
_0x2020026:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020027
	LDI  R16,LOW(1)
	RJMP _0x2020021
_0x2020027:
	CPI  R18,43
	BRNE _0x2020028
	LDI  R20,LOW(43)
	RJMP _0x2020021
_0x2020028:
	CPI  R18,32
	BRNE _0x2020029
	LDI  R20,LOW(32)
	RJMP _0x2020021
_0x2020029:
	RJMP _0x202002A
_0x2020025:
	CPI  R30,LOW(0x2)
	BRNE _0x202002B
_0x202002A:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x202002C
	ORI  R16,LOW(128)
	RJMP _0x2020021
_0x202002C:
	RJMP _0x202002D
_0x202002B:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x2020021
_0x202002D:
	CPI  R18,48
	BRLO _0x2020030
	CPI  R18,58
	BRLO _0x2020031
_0x2020030:
	RJMP _0x202002F
_0x2020031:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2020021
_0x202002F:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2020035
	CALL SUBOPT_0x3
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x4
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x73)
	BRNE _0x2020038
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020039
_0x2020038:
	CPI  R30,LOW(0x70)
	BRNE _0x202003B
	CALL SUBOPT_0x3
	CALL SUBOPT_0x5
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020039:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x202003C
_0x202003B:
	CPI  R30,LOW(0x64)
	BREQ _0x202003F
	CPI  R30,LOW(0x69)
	BRNE _0x2020040
_0x202003F:
	ORI  R16,LOW(4)
	RJMP _0x2020041
_0x2020040:
	CPI  R30,LOW(0x75)
	BRNE _0x2020042
_0x2020041:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x2020043
_0x2020042:
	CPI  R30,LOW(0x58)
	BRNE _0x2020045
	ORI  R16,LOW(8)
	RJMP _0x2020046
_0x2020045:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020077
_0x2020046:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x2020043:
	SBRS R16,2
	RJMP _0x2020048
	CALL SUBOPT_0x3
	CALL SUBOPT_0x6
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020049
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020049:
	CPI  R20,0
	BREQ _0x202004A
	SUBI R17,-LOW(1)
	RJMP _0x202004B
_0x202004A:
	ANDI R16,LOW(251)
_0x202004B:
	RJMP _0x202004C
_0x2020048:
	CALL SUBOPT_0x3
	CALL SUBOPT_0x6
_0x202004C:
_0x202003C:
	SBRC R16,0
	RJMP _0x202004D
_0x202004E:
	CP   R17,R21
	BRSH _0x2020050
	SBRS R16,7
	RJMP _0x2020051
	SBRS R16,2
	RJMP _0x2020052
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x2020053
_0x2020052:
	LDI  R18,LOW(48)
_0x2020053:
	RJMP _0x2020054
_0x2020051:
	LDI  R18,LOW(32)
_0x2020054:
	CALL SUBOPT_0x2
	SUBI R21,LOW(1)
	RJMP _0x202004E
_0x2020050:
_0x202004D:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x2020055
_0x2020056:
	CPI  R19,0
	BREQ _0x2020058
	SBRS R16,3
	RJMP _0x2020059
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x202005A
_0x2020059:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x202005A:
	CALL SUBOPT_0x2
	CPI  R21,0
	BREQ _0x202005B
	SUBI R21,LOW(1)
_0x202005B:
	SUBI R19,LOW(1)
	RJMP _0x2020056
_0x2020058:
	RJMP _0x202005C
_0x2020055:
_0x202005E:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2020060:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x2020062
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2020060
_0x2020062:
	CPI  R18,58
	BRLO _0x2020063
	SBRS R16,3
	RJMP _0x2020064
	SUBI R18,-LOW(7)
	RJMP _0x2020065
_0x2020064:
	SUBI R18,-LOW(39)
_0x2020065:
_0x2020063:
	SBRC R16,4
	RJMP _0x2020067
	CPI  R18,49
	BRSH _0x2020069
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020068
_0x2020069:
	RJMP _0x20200D3
_0x2020068:
	CP   R21,R19
	BRLO _0x202006D
	SBRS R16,0
	RJMP _0x202006E
_0x202006D:
	RJMP _0x202006C
_0x202006E:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x202006F
	LDI  R18,LOW(48)
_0x20200D3:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2020070
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x4
	CPI  R21,0
	BREQ _0x2020071
	SUBI R21,LOW(1)
_0x2020071:
_0x2020070:
_0x202006F:
_0x2020067:
	CALL SUBOPT_0x2
	CPI  R21,0
	BREQ _0x2020072
	SUBI R21,LOW(1)
_0x2020072:
_0x202006C:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x202005F
	RJMP _0x202005E
_0x202005F:
_0x202005C:
	SBRS R16,0
	RJMP _0x2020073
_0x2020074:
	CPI  R21,0
	BREQ _0x2020076
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x4
	RJMP _0x2020074
_0x2020076:
_0x2020073:
_0x2020077:
_0x2020036:
_0x20200D2:
	LDI  R17,LOW(0)
_0x2020021:
	RJMP _0x202001C
_0x202001E:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x7
	SBIW R30,0
	BRNE _0x2020078
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080001
_0x2020078:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x7
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 400
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x08
	.equ __w1_bit=0x05

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x780
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x4B
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USW 0x130
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x618
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xB
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x3B
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USW 0x140
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xB
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x45
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USW 0x12C
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1B
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
