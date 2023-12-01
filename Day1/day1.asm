INCLUDE C:\masm32\include\windows.inc
INCLUDE C:\masm32\include\kernel32.inc
INCLUDELIB C:\masm32\lib\kernel32.lib

.DATA
inputFileName BYTE "day1.txt", 0
outputFileName BYTE "output.txt", 0
successMessage BYTE "Works", 0
readBuffer BYTE 4096 DUP(?)
bytesRead DWORD ?
hInputFile HANDLE 0
hOutputFile HANDLE 0

.CODE
main PROC
    ; Open the input file
    SUB RSP, 50h
    MOV RCX, OFFSET inputFileName
    MOV RDX, GENERIC_READ
    XOR R8, R8
    XOR R9, R9
    MOV R10, OPEN_EXISTING
    MOV QWORD PTR [RSP+20h], 0
    MOV QWORD PTR [RSP+28h], 0
    CALL CreateFileA
    MOV hInputFile, RAX

    ; Read from the input file
    MOV RCX, hInputFile
    LEA RDX, readBuffer
    MOV R8, SIZEOF readBuffer
    LEA R9, OFFSET bytesRead
    XOR RAX, RAX
    CALL ReadFile
    CALL CloseHandle

    ; Open the output file
    MOV RCX, OFFSET outputFileName
    MOV RDX, GENERIC_WRITE
    XOR R8, R8
    XOR R9, R9
    MOV R10, CREATE_ALWAYS
    MOV QWORD PTR [RSP+20h], 0
    MOV QWORD PTR [RSP+28h], 0
    CALL CreateFileA
    MOV hOutputFile, RAX

    ; Write to the output file
    MOV RCX, hOutputFile
    LEA RDX, OFFSET successMessage
    MOV R8, SIZEOF successMessage - 1
    LEA R9, OFFSET bytesRead
    XOR RAX, RAX
    CALL WriteFile
    CALL CloseHandle

    ADD RSP, 50h
    RET

main ENDP
END main
