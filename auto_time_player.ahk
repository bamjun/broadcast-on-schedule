FileReadLine, l1, yingyec1.txt, 1
FileReadLine, l2, yingyec1.txt, 2
FileReadLine, l3, yingyec1.txt, 3
FileReadLine, l4, yingyec1.txt, 4
FileReadLine, l5, yingyec1.txt, 5
FileReadLine, l6, yingyec1.txt, 1
FileReadLine, l7, yingyec1.txt, 6
FileReadLine, l8, yingyec1.txt, 7

time_check(time_check_index_1)
{
    if (substr(time_check_index_1, -1) = 00) {
        time_check_index_1 := (substr(time_check_index_1, 1, 2)-1) . "59" . "58"
    }
    else {
        time_check_index_1 := substr(time_check_index_1, 1, 2) . substr("0" . substr(time_check_index_1, -1)-1, -1, 2) . "58"
    }
    return time_check_index_1
}
;-----------------------------------------------------
if (substr(l1, -1) = 50)
{
    l1 := (substr(l1, 1, 2)+1)00
    c1 = %l1%00
}
else
{
    l1 := l1+10
    c1 = %l1%00
}

;첫줄 영업시간시간 + 10분  
;-> 9시영업시간이면 091000
;-----------------------------------------------------
if (substr(l2, -1) > 19)
{
    l2 := (substr(l2, 1, 2)-2)00
    c2 = %l2%00
}
else
{
    c2 := (substr(l2, 1, 2)-2)
    c2 = %c2%20
    c2 = %c2%00
}
;두번째줄 영업마감시간 - 1시간40분 
;-> 영업종료시간이 6시면 162000
;-----------------------------------------------------

c3 := time_check(l3)
c4 := time_check(l4)
c5 := time_check(l5)
c6 := time_check(l6)
c7 := time_check(l7)
c8 := time_check(l8)

start_time = %A_Hour%%A_Min%%A_Sec%

time_break_index(start_index, end_index, func_execute_check)
{
    if (func_execute_check = 1)
    {
        return
    }

    now_index = %A_Hour%%A_Min%%A_Sec%

    if now_index between %start_index% and %end_index%
    {
        time_break_return_index := (((substr(end_index,1,2)-substr(now_index,1,2))*3600000) + ((substr(end_index,3,2)-substr(now_index,3,2))*60000) + ((substr(end_index,5,2)-substr(now_index,5,2))*1000))-60000
        sleep % time_break_return_index
        return 1
    } 

}

time_break_check_index_1 = 0
time_break_check_index_2 = 0
time_break_check_index_3 = 0
time_break_check_index_4 = 0

loop
{
    siggan = %A_Hour%%A_Min%%A_Sec%

    time_break_check_index_1 := time_break_index(start_time,c1,time_break_check_index_1)
    ;영업시작전까지
    time_break_check_index_2 := time_break_index(c1,c7,time_break_check_index_2)
    ;오픈후 1차 마스크
    time_break_check_index_3 := time_break_index(c7,c8,time_break_check_index_3)
    ;1차마스크, 2차마스크
    time_break_check_index_4 := time_break_index(c8,c4,time_break_check_index_4)
    ;2차마스크, 마감

    if siggan = %c6%
    {

        WinGet, ChromePIDVariable, PID, ahk_exe Melon Player.exe ;;; 멜론 0으로 ahk_exe Melon.exe 멜론 
        VA_SetAppVolume(ChromePIDVariable, 50)
        sleep, 1000
        Run, 01.mp3 ;;;;오프닝노래
        VA_SetAppVolume(ChromePIDVariable, 10)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 0)
        SLEEP, 3500
        WinGet, hohoao123, PID, ahk_exe wmplayer.exe
        VA_SetAppVolume(hohoao123, 50)
        sleep, 1000
        VA_SetAppVolume(hohoao123, 30)
        sleep, 1000
        VA_SetAppVolume(hohoao123, 20)
        sleep, 1000
        VA_SetAppVolume(hohoao123, 10)
        sleep, 1000
        Run, 02.wav ;;;;시작15분노래
        VA_SetAppVolume(hohoao123, 60)
        ;	SLEEP, 123000      ;시간대기
        SLEEP, 28500 ;시간대기
        WinKill, Windows Media Player ;;노래끄기
        VA_SetAppVolume(ChromePIDVariable, 40)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 60)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 80)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 100) ;;; 멜론 100으로
    }

    /*
    -------------- 1730 방송
    if siggan = %c3%
    {
        WinGet, ChromePIDVariable, PID, ahk_exe Melon Player.exe  ;;; 멜론 0으로
        VA_SetAppVolume(ChromePIDVariable, 65)
        sleep, 400
        VA_SetAppVolume(ChromePIDVariable, 40)
        sleep, 200
        Run, 02.wav   ;;;;시작15분노래
        VA_SetAppVolume(ChromePIDVariable, 20)
        sleep, 400
        VA_SetAppVolume(ChromePIDVariable, 0)
        ;SLEEP, 122500      ;시간대기
        SLEEP, 28500      ;시간대기
        WinKill, Windows Media Player             ;;노래끄기
        VA_SetAppVolume(ChromePIDVariable, 40)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 60)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 80)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 100)  ;;; 멜론 100으로
    }
    */

    if siggan = %c4%
    {
        WinGet, ChromePIDVariable, PID, ahk_exe Melon Player.exe ;;; 멜론 0으로
        VA_SetAppVolume(ChromePIDVariable, 65)
        sleep, 400
        VA_SetAppVolume(ChromePIDVariable, 40)
        sleep, 200
        Run, 03.mp3 ;;;;시작15분노래
        VA_SetAppVolume(ChromePIDVariable, 20)
        sleep, 400
        VA_SetAppVolume(ChromePIDVariable, 0)
        ;SLEEP, 121500      ;시간대기
        SLEEP, 41500 ;시간대기
        Run, 04.mp3 ;;;;시작15분노래
    }

    if siggan = %c5%
    {
        Run, 06endvo.mp3 ;;;;마지막 방송
        SLEEP, 7000
        WinKill, Windows Media Player 
        SLEEP, 600000
        ;WinGet, ChromePIDVariable, PID, ahk_exe Melon Player.exe
        ;VA_SetAppVolume(ChromePIDVariable, 100)
    }

    if siggan = %c7%
    {
        WinGet, ChromePIDVariable, PID, ahk_exe Melon Player.exe ;;; 멜론 0으로
        VA_SetAppVolume(ChromePIDVariable, 65)
        sleep, 400
        VA_SetAppVolume(ChromePIDVariable, 40)
        sleep, 200
        Run, 05mask.mp3 ;;;;시작15분노래
        VA_SetAppVolume(ChromePIDVariable, 20)
        sleep, 400
        VA_SetAppVolume(ChromePIDVariable, 0)
        ;SLEEP, 122500      ;시간대기
        SLEEP, 29000 ;시간대기
        WinKill, Windows Media Player ;;노래끄기
        VA_SetAppVolume(ChromePIDVariable, 40)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 60)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 80)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 100) ;;; 멜론 100으로
    }

    if siggan = %c8%
    {
        WinGet, ChromePIDVariable, PID, ahk_exe Melon Player.exe ;;; 멜론 0으로
        VA_SetAppVolume(ChromePIDVariable, 65)
        sleep, 400
        VA_SetAppVolume(ChromePIDVariable, 40)
        sleep, 200
        Run, 05mask.mp3 ;;;;시작15분노래
        VA_SetAppVolume(ChromePIDVariable, 20)
        sleep, 400
        VA_SetAppVolume(ChromePIDVariable, 0)
        ;SLEEP, 122500      ;시간대기
        SLEEP, 29000 ;시간대기
        WinKill, Windows Media Player ;;노래끄기
        VA_SetAppVolume(ChromePIDVariable, 40)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 60)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 80)
        sleep, 1000
        VA_SetAppVolume(ChromePIDVariable, 100) ;;; 멜론 100으로
    }

    sleep, 998
}
return 

#Include VA.ahk
#Include vovovol.ahk

return