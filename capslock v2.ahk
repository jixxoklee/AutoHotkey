#Requires AutoHotkey v2.0

; 이동 거리 설정
initial_move := 2    ; 초기 이동 거리 (더 작은 값으로 시작)
max_move := 32         ; 최대 이동 거리 (약간 줄임)
accel_rate := 1.1     ; 가속도 비율 (약간 낮춤)
decel_rate := 0.95     ; 감속도 비율 (키를 놓았을 때 서서히 감속)
diagonal_factor := 0.7 ; 대각선 이동 시 사용할 계수
scroll_amount := 1     ; 스크롤 양
sleep_duration := 8    ; Sleep 시간 (ms) - 반응성 향상을 위해 약간 줄임

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
        if GetKeyState("j", "P") {
            x := -diagonal_factor
            y *= diagonal_factor
        } else if GetKeyState("l", "P") {
            x := diagonal_factor
            y *= diagonal_factor
        }
        Accel(x, y, &move_dist)
        Sleep sleep_duration
    }
    move_dist *= decel_rate  ; 키를 놓았을 때 감속
}

CapsLock & k::
{
    move_dist := initial_move
    while GetKeyState("k", "P") {
        x := 0
        y := 1
        if GetKeyState("j", "P") {
            x := -diagonal_factor
            y *= diagonal_factor
        } else if GetKeyState("l", "P") {
            x := diagonal_factor
            y *= diagonal_factor
        }
        Accel(x, y, &move_dist)
        Sleep sleep_duration
    }
    move_dist *= decel_rate  ; 키를 놓았을 때 감속
}

CapsLock & j::
{
    move_dist := initial_move
    while GetKeyState("j", "P") {
        x := -1
        y := 0
        if GetKeyState("i", "P") {
            y := -diagonal_factor
            x *= diagonal_factor
        } else if GetKeyState("k", "P") {
            y := diagonal_factor
            x *= diagonal_factor
        }
        Accel(x, y, &move_dist)
        Sleep sleep_duration
    }
    move_dist *= decel_rate  ; 키를 놓았을 때 감속
}

CapsLock & l::
{
    move_dist := initial_move
    while GetKeyState("l", "P") {
        x := 1
        y := 0
        if GetKeyState("i", "P") {
            y := -diagonal_factor
            x *= diagonal_factor
        } else if GetKeyState("k", "P") {
            y := diagonal_factor
            x *= diagonal_factor
        }
        Accel(x, y, &move_dist)
        Sleep sleep_duration
    }
    move_dist *= decel_rate  ; 키를 놓았을 때 감속
}


; 마우스 클릭
CapsLock & r::Click()          ; CapsLock + r를 누르면 좌클릭
CapsLock & t::Click("right")   ; CapsLock + t를 누르면 우클릭

CapsLock & u::  ; CapsLock + u를 누르면 위로 스크롤
{
    while GetKeyState("u", "P") and GetKeyState("CapsLock", "P") {
        Click("WheelUp")
        Sleep 100
    }
}

CapsLock & o::  ; CapsLock + o를 누르면 아래로 스크롤
{
    while GetKeyState("o", "P") and GetKeyState("CapsLock", "P") {
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
r::Send "{Blind}{r}"
t::Send "{Blind}{t}"
u::Send "{Blind}{u}"
o::Send "{Blind}{o}"
#HotIf