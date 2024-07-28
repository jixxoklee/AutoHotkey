#Requires AutoHotkey v2.0

; 이동 거리 설정
initial_move := 0.8  ; 초기 이동 거리
max_move := 16     ; 최대 이동 거리
accel_rate := 1.1  ; 가속도 비율 (1보다 크면 가속, 1이면 일정 속도)
scroll_amount := 1 ; 스크롤 양

; 마우스 이동 함수
Accel(x, y, &move_dist) {
    MouseMove(x * move_dist, y * move_dist, 0, "R")
    move_dist := Min(move_dist * accel_rate, max_move)
}

; CapsLock을 modifier로 사용하기 위한 설정
*CapsLock::
{
    KeyWait "CapsLock"
    if (A_PriorKey = "CapsLock")
        SetCapsLockState !GetKeyState("CapsLock", "T")
}

; 마우스 커서 이동 (직선 및 대각선)
CapsLock & i::
{
    move_dist := initial_move
    while GetKeyState("i", "P") {
        x := 0
        y := -1
        if GetKeyState("j", "P")
            x := -0.7
        else if GetKeyState("l", "P")
            x := 0.7
        Accel(x, y, &move_dist)
        Sleep 10
    }
}

CapsLock & k::
{
    move_dist := initial_move
    while GetKeyState("k", "P") {
        x := 0
        y := 1
        if GetKeyState("j", "P")
            x := -0.7
        else if GetKeyState("l", "P")
            x := 0.7
        Accel(x, y, &move_dist)
        Sleep 10
    }
}

CapsLock & j::
{
    move_dist := initial_move
    while GetKeyState("j", "P") {
        x := -1
        y := 0
        if GetKeyState("i", "P")
            y := -0.7
        else if GetKeyState("k", "P")
            y := 0.7
        Accel(x, y, &move_dist)
        Sleep 10
    }
}

CapsLock & l::
{
    move_dist := initial_move
    while GetKeyState("l", "P") {
        x := 1
        y := 0
        if GetKeyState("i", "P")
            y := -0.7
        else if GetKeyState("k", "P")
            y := 0.7
        Accel(x, y, &move_dist)
        Sleep 10
    }
}

; 마우스 클릭
CapsLock & u::Click()          ; CapsLock + u를 누르면 클릭
CapsLock & o::Click("right")   ; CapsLock + o를 누르면 우클릭

CapsLock & 9::  ; CapsLock + 9를 누르면 위로 스크롤
{
    while GetKeyState("9", "P") {
        Click("WheelUp")
        Sleep 100
    }
}

CapsLock & m::  ; CapsLock + m을 누르면 아래로 스크롤
{
    while GetKeyState("m", "P") {
        Click("WheelDown")
        Sleep 100
    }
}

; CapsLock 키의 기본 기능 유지
#HotIf GetKeyState("CapsLock", "P")
i::Send "{Blind}{i}"
j::Send "{Blind}{j}"
k::Send "{Blind}{k}"
l::Send "{Blind}{l}"
u::Send "{Blind}{u}"
o::Send "{Blind}{o}"
9::Send "{Blind}{9}"
m::Send "{Blind}{m}"
#HotIf